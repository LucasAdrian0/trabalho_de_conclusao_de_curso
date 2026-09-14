import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';
import '../../domain/entities/solicitacao_entity.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/enums/tipo_servico_solicitado.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../datasources/solicitacao_remote_datasource.dart';
import '../models/solicitacao_model.dart';

class SolicitacaoRepositoryImpl implements SolicitacaoRepository {
  final SolicitacaoRemoteDataSource remoteDataSource;

  SolicitacaoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SolicitacaoEntity?> buscarPorId(String id) =>
      executarRepositorio(() async {
        final model = await remoteDataSource.buscarPorId(id);
        return model?.toEntity();
      });

  @override
  Future<List<SolicitacaoEntity>> listarPorClienteId(String clienteId) =>
      executarRepositorio(() async {
        final models = await remoteDataSource.listarPorClienteId(clienteId);
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<List<SolicitacaoEntity>> listarAbertasPorRegiao(
    String cidade,
    String estado, {
    TipoServicoSolicitado? tipoServico,
  }) => executarRepositorio(() async {
    final models = await remoteDataSource.listarAbertasPorRegiao(
      cidade,
      estado,
      tipoServico: tipoServico,
    );
    return models.map((model) => model.toEntity()).toList();
  });

  @override
  Future<void> salvar(SolicitacaoEntity solicitacao) =>
      executarRepositorio(() async {
        final model = SolicitacaoModel.fromEntity(solicitacao);
        await remoteDataSource.salvar(model);
      });

  @override
  Future<void> atualizarStatus(
    String solicitacaoId,
    StatusSolicitacao status,
  ) => executarRepositorio(() async {
    // Converte o Enum para String (status.databaseValue) ao repassar para a DataSource/Supabase
    await remoteDataSource.atualizarStatus(solicitacaoId, status.databaseValue);
  });
}
