import 'package:flutter_test/flutter_test.dart';
import 'package:tcc_frete_urbano/application/usecases/atualizar_status_servico.dart';
import 'package:tcc_frete_urbano/application/usecases/auth_use_cases.dart';
import 'package:tcc_frete_urbano/application/usecases/criar_solicitacao.dart';
import 'package:tcc_frete_urbano/application/usecases/gerar_cotacoes_automaticas.dart';
import 'package:tcc_frete_urbano/domain/entities/cliente_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/endereco_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/item_mudanca_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/servico_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/solicitacao_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/usuario_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/orcamento_entity.dart';
import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_endereco.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_servico_solicitado.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_usuario.dart';
import 'package:tcc_frete_urbano/domain/errors/falha.dart';
import 'package:tcc_frete_urbano/domain/repositories/auth_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/cliente_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/servico_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/solicitacao_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/orcamento_repository.dart';

Matcher falha(TipoFalha tipo) =>
    isA<Falha>().having((e) => e.tipo, 'tipo', tipo);

class AuthFake implements AuthRepository {
  @override
  String? usuarioId = 'cliente';
  int cadastros = 0;
  String? emailRecebido;
  String? senhaRecebida;
  @override
  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nome,
    required TipoUsuario tipo,
  }) async {
    cadastros++;
    emailRecebido = email;
    senhaRecebida = senha;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ClientesFake implements ClienteRepository {
  @override
  Future<ClienteEntity?> buscarPorUsuarioId(String id) async => ClienteEntity(
    usuario: UsuarioEntity(
      id: id,
      tipo: TipoUsuario.cliente,
      nome: 'Ana',
      email: 'ana@example.com',
      criadoEm: DateTime.utc(2026),
      atualizadoEm: DateTime.utc(2026),
    ),
    cpf: '52998224725',
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SolicitacoesFake implements SolicitacaoRepository {
  int gravacoes = 0;
  SolicitacaoEntity? recebida;
  final SolicitacaoEntity existente;
  SolicitacoesFake(this.existente);

  @override
  Future<void> salvar(SolicitacaoEntity solicitacao) async {
    gravacoes++;
    recebida = solicitacao;
  }

  @override
  Future<SolicitacaoEntity?> buscarPorId(String id) async => existente;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ServicosFake implements ServicoRepository {
  int alteracoes = 0;
  final ServicoEntity servico = ServicoEntity(
    id: 'servico',
    solicitacaoId: 's',
    orcamentoId: 'o',
    prestadorId: 'prestador',
    veiculoId: 'v',
    status: StatusSolicitacao.agendado,
    criadoEm: DateTime.utc(2026),
  );

  @override
  Future<ServicoEntity?> buscarPorId(String id) async => servico;
  @override
  Future<void> atualizarStatus(String id, StatusSolicitacao status) async {
    alteracoes++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class OrcamentosFake implements OrcamentoRepository {
  int geracoes = 0;

  @override
  Future<List<OrcamentoEntity>> gerarAutomaticos(String solicitacaoId) async {
    geracoes++;
    return [
      OrcamentoEntity(
        id: 'orcamento',
        solicitacaoId: solicitacaoId,
        prestadorId: 'prestador',
        veiculoId: 'veiculo',
        valorTransporte: 50,
        valorTotal: 50,
        status: StatusOrcamento.pendente,
        criadoEm: DateTime.utc(2026),
      ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SolicitacaoEntity solicitacao({int quantidade = 1}) {
  final agora = DateTime.utc(2026);
  final origem = EnderecoEntity(
    id: 'origem',
    usuarioId: 'cliente',
    tipo: TipoEndereco.origem,
    logradouro: 'Rua A',
    cidade: 'Ourinhos',
    estado: 'SP',
    criadoEm: agora,
  );
  return SolicitacaoEntity(
    id: 's',
    clienteId: 'cliente',
    enderecoOrigem: origem,
    enderecoDestino: EnderecoEntity(
      id: 'destino',
      usuarioId: 'cliente',
      tipo: TipoEndereco.destino,
      logradouro: 'Rua B',
      cidade: 'Ourinhos',
      estado: 'SP',
      criadoEm: agora,
    ),
    dataDesejada: DateTime.utc(2026, 10),
    tipoServico: TipoServicoSolicitado.frete,
    volumeEstimadoM3: 1,
    distanciaKm: 10,
    status: StatusSolicitacao.aguardandoPrestador,
    criadoEm: agora,
    atualizadoEm: agora,
    itens: [
      ItemMudancaEntity(
        id: 'i',
        solicitacaoId: 's',
        descricao: 'Caixa',
        quantidade: quantidade,
      ),
    ],
  );
}

void main() {
  test('cadastro valida antes de acessar o repositório', () async {
    final auth = AuthFake();
    await expectLater(
      CadastrarUsuario(auth)(
        email: 'inválido',
        senha: '12345678',
        nome: 'Ana',
        tipo: TipoUsuario.cliente,
      ),
      throwsA(falha(TipoFalha.validacao)),
    );
    expect(auth.cadastros, 0);
  });

  test('cadastro normaliza e-mail e preserva a senha exata', () async {
    final auth = AuthFake();
    await CadastrarUsuario(auth)(
      email: ' ana@example.com ',
      senha: ' senha123 ',
      nome: ' Ana ',
      tipo: TipoUsuario.cliente,
    );
    expect(auth.emailRecebido, 'ana@example.com');
    expect(auth.senhaRecebida, ' senha123 ');
  });

  test('solicitação exige sessão', () async {
    final auth = AuthFake()..usuarioId = null;
    final pedido = solicitacao();
    final repo = SolicitacoesFake(pedido);
    await expectLater(
      CriarSolicitacao(auth, ClientesFake(), repo)(pedido),
      throwsA(falha(TipoFalha.naoAutenticado)),
    );
    expect(repo.gravacoes, 0);
  });

  test('solicitação rejeita item inválido', () async {
    final pedido = solicitacao(quantidade: -1);
    final repo = SolicitacoesFake(pedido);
    await expectLater(
      CriarSolicitacao(AuthFake(), ClientesFake(), repo)(pedido),
      throwsA(falha(TipoFalha.validacao)),
    );
    expect(repo.gravacoes, 0);
  });

  test('solicitação completa é gravada em uma operação', () async {
    final pedido = solicitacao();
    final repo = SolicitacoesFake(pedido);
    await CriarSolicitacao(AuthFake(), ClientesFake(), repo)(pedido);
    expect(repo.recebida, same(pedido));
    expect(repo.recebida!.itens, hasLength(1));
  });

  test('cliente pode solicitar cotações automáticas para sua solicitação', () async {
    final pedido = solicitacao();
    final orcamentos = OrcamentosFake();
    final resultado = await GerarCotacoesAutomaticas(
      AuthFake(),
      SolicitacoesFake(pedido),
      orcamentos,
    )(pedido.id);
    expect(orcamentos.geracoes, 1);
    expect(resultado.single.valorTotal, 50);
  });

  test('cliente não pode iniciar o serviço do prestador', () async {
    final pedido = solicitacao();
    final servicos = ServicosFake();
    await expectLater(
      AtualizarStatusServico(AuthFake(), servicos, SolicitacoesFake(pedido))(
        servicoId: 'servico',
        novoStatus: StatusSolicitacao.emAndamento,
      ),
      throwsA(falha(TipoFalha.conflito)),
    );
    expect(servicos.alteracoes, 0);
  });

  test('prestador pode iniciar seu serviço agendado', () async {
    final pedido = solicitacao();
    final servicos = ServicosFake();
    await AtualizarStatusServico(
      AuthFake()..usuarioId = 'prestador',
      servicos,
      SolicitacoesFake(pedido),
    )(servicoId: 'servico', novoStatus: StatusSolicitacao.emAndamento);
    expect(servicos.alteracoes, 1);
  });
}
