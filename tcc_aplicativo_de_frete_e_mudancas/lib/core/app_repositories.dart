import '../application/usecases/auth_use_cases.dart';
import '../application/usecases/criar_solicitacao.dart';
import '../application/usecases/aceitar_orcamento.dart';
import '../application/usecases/atualizar_status_servico.dart';
import '../application/usecases/atualizar_status_solicitacao.dart';
import '../application/usecases/criar_orcamento.dart';
import '../application/usecases/recusar_orcamento.dart';
import '../application/usecases/avaliar_servico.dart';
import '../application/usecases/perfil_use_cases.dart';
import '../application/usecases/consulta_use_cases.dart';
import '../application/app_use_cases.dart';
import '../data/datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/usuario_repository.dart';
import '../data/repositories/usuario_repository_impl.dart';
import '../data/datasources/usuario_remote_datasouce.dart';
import '../domain/repositories/cliente_repository.dart';
import '../data/repositories/cliente_repository_impl.dart';
import '../data/datasources/cliente_remote_datasource.dart';
import '../domain/repositories/prestador_repository.dart';
import '../data/repositories/prestador_repository_impl.dart';
import '../data/datasources/prestador_remote_datasource.dart';
import '../domain/repositories/endereco_repository.dart';
import '../data/repositories/endereco_repository_impl.dart';
import '../data/datasources/endereco_remote_datasouce.dart';
import '../domain/repositories/solicitacao_repository.dart';
import '../data/repositories/solicitacao_repository_impl.dart';
import '../data/datasources/solicitacao_remote_datasource.dart';
import '../domain/repositories/servico_repository.dart';
import '../data/repositories/servico_repository_impl.dart';
import '../data/datasources/servico_remote_datasouce.dart';
import '../domain/repositories/veiculo_repository.dart';
import '../data/repositories/veicuplo_repository_impl.dart';
import '../data/datasources/veiculo_remote_datasource.dart';
import '../domain/repositories/pagamento_repository.dart';
import '../data/repositories/pagamento_repository_impl.dart';
import '../data/datasources/pagamento_remote_datasouce.dart';
import '../domain/repositories/avaliacao_repository.dart';
import '../data/repositories/avaliacao_repository_impl.dart';
import '../data/datasources/avaliacao_remote_datasource.dart';
import '../domain/repositories/notificacoes_repository.dart';
import '../data/repositories/notificacoes_repository_impl.dart';
import '../data/datasources/notificacoes_remote_datasource.dart';
import '../domain/repositories/orcamento_repository.dart';
import '../data/repositories/orcamento_repository_impl.dart';
import '../data/datasources/orcamento_remote_datasouce.dart';

class AppRepositories {
  final SupabaseClient client;
  AppRepositories(this.client);
  late final AuthRepository auth = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(client),
  );
  late final UsuarioRepository usuario = UsuarioRepositoryImpl(
    remoteDataSource: UsuarioRemoteDataSourceImpl(supabase: client),
  );
  late final ClienteRepository cliente = ClienteRepositoryImpl(
    remoteDataSource: ClienteRemoteDataSourceImpl(supabase: client),
  );
  late final PrestadorRepository prestador = PrestadorRepositoryImpl(
    remoteDataSource: PrestadorRemoteDataSourceImpl(supabase: client),
  );
  late final EnderecoRepository endereco = EnderecoRepositoryImpl(
    remoteDataSource: EnderecoRemoteDataSourceImpl(supabase: client),
  );
  late final SolicitacaoRepository solicitacao = SolicitacaoRepositoryImpl(
    remoteDataSource: SolicitacaoRemoteDataSourceImpl(supabase: client),
  );
  late final ServicoRepository servico = ServicoRepositoryImpl(
    remoteDataSource: ServicoRemoteDataSourceImpl(supabase: client),
  );
  late final VeiculoRepository veiculo = VeiculoRepositoryImpl(
    remoteDataSource: VeiculoRemoteDataSourceImpl(supabase: client),
  );
  late final PagamentoRepository pagamento = PagamentoRepositoryImpl(
    remoteDataSource: PagamentoRemoteDataSourceImpl(supabase: client),
  );
  late final AvaliacaoRepository avaliacao = AvaliacaoRepositoryImpl(
    remoteDataSource: AvaliacaoRemoteDataSourceImpl(supabase: client),
  );
  late final NotificacoesRepository notificacoes = NotificacoesRepositoryImpl(
    remoteDataSource: NotificacoesRemoteDataSourceImpl(supabase: client),
  );
  late final OrcamentoRepository orcamento = OrcamentoRepositoryImpl(
    OrcamentoRemoteDataSourceImpl(client),
  );
  late final AppUseCases useCases = AppUseCases(
    cadastrarUsuario: CadastrarUsuario(auth),
    entrar: Entrar(auth),
    sair: Sair(auth),
    recuperarSenha: RecuperarSenha(auth),
    observarSessao: ObservarSessao(auth),
    criarSolicitacao: CriarSolicitacao(auth, cliente, solicitacao),
    aceitarOrcamento: AceitarOrcamento(auth, servico),
    atualizarStatusServico: AtualizarStatusServico(auth, servico),
    atualizarStatusSolicitacao: AtualizarStatusSolicitacao(auth, solicitacao),
    criarOrcamento: CriarOrcamento(auth, orcamento, solicitacao, veiculo),
    recusarOrcamento: RecusarOrcamento(auth, orcamento),
    avaliarServico: AvaliarServico(auth, avaliacao, servico),
    atualizarPerfil: AtualizarPerfil(auth, usuario),
    completarCadastroCliente: CompletarCadastroCliente(auth, cliente),
    cadastrarPrestador: CadastrarPrestador(auth, prestador),
    atualizarPrestador: AtualizarPrestador(auth, prestador),
    salvarVeiculo: SalvarVeiculo(auth, veiculo),
    consultarMeuPerfil: ConsultarMeuPerfil(auth, usuario),
    consultarPagamento: ConsultarPagamento(auth, pagamento),
    listarMinhasNotificacoes: ListarMinhasNotificacoes(auth, notificacoes),
    marcarNotificacaoComoLida: MarcarNotificacaoComoLida(auth, notificacoes),
    listarMinhasSolicitacoes: ListarMinhasSolicitacoes(auth, solicitacao),
    listarServicosComoCliente: ListarServicosComoCliente(auth, servico),
    listarServicosComoPrestador: ListarServicosComoPrestador(auth, servico),
  );
}
