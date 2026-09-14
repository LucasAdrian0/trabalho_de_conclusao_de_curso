import 'package:flutter_test/flutter_test.dart';
import 'package:tcc_frete_urbano/application/usecases/auth_use_cases.dart';
import 'package:tcc_frete_urbano/application/usecases/criar_solicitacao.dart';
import 'package:tcc_frete_urbano/application/usecases/aceitar_orcamento.dart';
import 'package:tcc_frete_urbano/application/usecases/atualizar_status_servico.dart';
import 'package:tcc_frete_urbano/domain/entities/cliente_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/usuario_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/solicitacao_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/endereco_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/item_solicitado.dart';
import 'package:tcc_frete_urbano/domain/entities/servico_entity.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_usuario.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_endereco.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_servico_solicitado.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/status_servico.dart';
import 'package:tcc_frete_urbano/domain/errors/falha.dart';
import 'package:tcc_frete_urbano/domain/repositories/auth_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/cliente_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/solicitacao_repository.dart';
import 'package:tcc_frete_urbano/domain/repositories/servico_repository.dart';

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
      emailVerificado: true,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    ),
    cpf: '52998224725',
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class SolicitacoesFake implements SolicitacaoRepository {
  int gravacoes = 0;
  SolicitacaoEntity? recebida;
  @override
  Future<void> salvar(SolicitacaoEntity solicitacao) async {
    gravacoes++;
    recebida = solicitacao;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ServicosFake implements ServicoRepository {
  int aceites = 0;
  int alteracoes = 0;
  final ServicoEntity servico = ServicoEntity(
    id: 'servico',
    solicitacaoId: 's',
    orcamentoId: 'o',
    clienteId: 'cliente',
    prestadorId: 'prestador',
    veiculoId: 'v',
    valorTotal: 100,
    status: StatusServico.agendado,
    dataAgendada: DateTime.utc(2026),
    horarioAgendado: '10:00',
  );
  @override
  Future<ServicoEntity> aceitarOrcamento(String orcamentoId) async {
    aceites++;
    return servico;
  }

  @override
  Future<ServicoEntity?> buscarPorId(String id) async => servico;
  @override
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus,
    String? observacao,
  }) async {
    alteracoes++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

SolicitacaoEntity solicitacao({int quantidade = 1}) {
  const origem = EnderecoEntity(
    id: 'origem',
    usuarioId: 'cliente',
    tipo: TipoEndereco.origem,
    cep: '19900000',
    logradouro: 'Rua A',
    numero: '1',
    bairro: 'Centro',
    cidade: 'Ourinhos',
    estado: 'SP',
  );
  return SolicitacaoEntity(
    id: 's',
    clienteId: 'cliente',
    enderecoOrigem: origem,
    enderecoDestino: origem,
    dataDesejada: DateTime.utc(2026, 10),
    horarioDesejado: '10:00',
    tiposervico: TipoServicoSolicitado.fretePequeno,
    volumeEstimadoM3: 1,
    distanciaKm: 10,
    duracaoEstimadaMin: 20,
    status: StatusSolicitacao.aguardandoPrestador,
    itens: [
      ItemSolicitacao(
        id: 'i',
        solicitacaoId: 's',
        nome: 'Caixa',
        categoria: 'caixas',
        quantidade: quantidade,
      ),
    ],
  );
}

void main() {
  test('Cadastro valida antes de acessar o repositório', () async {
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
  test('Cadastro normaliza e-mail e preserva a senha exata', () async {
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
  test('Solicitação exige sessão e não grava dados sem login', () async {
    final auth = AuthFake()..usuarioId = null;
    final repo = SolicitacoesFake();
    await expectLater(
      CriarSolicitacao(auth, ClientesFake(), repo)(solicitacao()),
      throwsA(falha(TipoFalha.naoAutenticado)),
    );
    expect(repo.gravacoes, 0);
  });
  test('Solicitação rejeita item inválido antes da persistência', () async {
    final repo = SolicitacoesFake();
    await expectLater(
      CriarSolicitacao(AuthFake(), ClientesFake(), repo)(
        solicitacao(quantidade: -1),
      ),
      throwsA(falha(TipoFalha.validacao)),
    );
    expect(repo.gravacoes, 0);
  });
  test('Solicitação válida chega completa numa única operação', () async {
    final repo = SolicitacoesFake();
    final pedido = solicitacao();
    await CriarSolicitacao(AuthFake(), ClientesFake(), repo)(pedido);
    expect(repo.gravacoes, 1);
    expect(repo.recebida, same(pedido));
    expect(repo.recebida!.itens, hasLength(1));
  });
  test('Aceite é uma única operação de domínio', () async {
    final repo = ServicosFake();
    expect(await AceitarOrcamento(AuthFake(), repo)('o'), same(repo.servico));
    expect(repo.aceites, 1);
  });
  test('Cliente não pode iniciar o serviço do prestador', () async {
    final repo = ServicosFake();
    await expectLater(
      AtualizarStatusServico(AuthFake(), repo)(
        servicoId: 'servico',
        novoStatus: StatusServico.emAndamento,
      ),
      throwsA(falha(TipoFalha.conflito)),
    );
    expect(repo.alteracoes, 0);
  });
  test('Prestador pode iniciar seu serviço agendado', () async {
    final repo = ServicosFake();
    await AtualizarStatusServico(AuthFake()..usuarioId = 'prestador', repo)(
      servicoId: 'servico',
      novoStatus: StatusServico.emAndamento,
    );
    expect(repo.alteracoes, 1);
  });
}
