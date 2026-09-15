import 'usecases/auth_use_cases.dart';
import 'usecases/criar_solicitacao.dart';
import 'usecases/aceitar_orcamento.dart';
import 'usecases/atualizar_status_servico.dart';
import 'usecases/atualizar_status_solicitacao.dart';
import 'usecases/criar_orcamento.dart';
import 'usecases/recusar_orcamento.dart';
import 'usecases/avaliar_servico.dart';
import 'usecases/perfil_use_cases.dart';
import 'usecases/consulta_use_cases.dart';
import 'usecases/gerar_cotacoes_automaticas.dart';

/// Dependências oferecidas à apresentação; não expõe repositórios ou SDKs.
class AppUseCases {
  final CadastrarUsuario cadastrarUsuario;
  final Entrar entrar;
  final Sair sair;
  final RecuperarSenha recuperarSenha;
  final ObservarSessao observarSessao;
  final CriarSolicitacao criarSolicitacao;
  final AceitarOrcamento aceitarOrcamento;
  final AtualizarStatusServico atualizarStatusServico;
  final AtualizarStatusSolicitacao atualizarStatusSolicitacao;
  final CriarOrcamento criarOrcamento;
  final GerarCotacoesAutomaticas gerarCotacoesAutomaticas;
  final RecusarOrcamento recusarOrcamento;
  final AvaliarServico avaliarServico;
  final AtualizarPerfil atualizarPerfil;
  final CompletarCadastroCliente completarCadastroCliente;
  final CadastrarPrestador cadastrarPrestador;
  final AtualizarPrestador atualizarPrestador;
  final SalvarVeiculo salvarVeiculo;
  final SalvarAjudante salvarAjudante;
  final ConsultarMeuPerfil consultarMeuPerfil;
  final ConsultarPagamento consultarPagamento;
  final ListarMinhasNotificacoes listarMinhasNotificacoes;
  final MarcarNotificacaoComoLida marcarNotificacaoComoLida;
  final ListarMinhasSolicitacoes listarMinhasSolicitacoes;
  final ListarOrcamentosDaSolicitacao listarOrcamentosDaSolicitacao;
  final ListarServicosComoCliente listarServicosComoCliente;
  final ListarServicosComoPrestador listarServicosComoPrestador;
  const AppUseCases({
    required this.cadastrarUsuario,
    required this.entrar,
    required this.sair,
    required this.recuperarSenha,
    required this.observarSessao,
    required this.criarSolicitacao,
    required this.aceitarOrcamento,
    required this.atualizarStatusServico,
    required this.atualizarStatusSolicitacao,
    required this.criarOrcamento,
    required this.gerarCotacoesAutomaticas,
    required this.recusarOrcamento,
    required this.avaliarServico,
    required this.atualizarPerfil,
    required this.completarCadastroCliente,
    required this.cadastrarPrestador,
    required this.atualizarPrestador,
    required this.salvarVeiculo,
    required this.salvarAjudante,
    required this.consultarMeuPerfil,
    required this.consultarPagamento,
    required this.listarMinhasNotificacoes,
    required this.marcarNotificacaoComoLida,
    required this.listarMinhasSolicitacoes,
    required this.listarOrcamentosDaSolicitacao,
    required this.listarServicosComoCliente,
    required this.listarServicosComoPrestador,
  });
}
