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
  Future<SolicitacaoEntity?> buscarPorId(String id) async {
    final model = await remoteDataSource.buscarPorId(id);
    return model?.toEntity();
  }

  @override
  Future<List<SolicitacaoEntity>> listarPorClienteId(String clienteId) async {
    final models = await remoteDataSource.listarPorClienteId(clienteId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<SolicitacaoEntity>> listarAbertasPorRegiao(
    String cidade, 
    String estado, {
    TipoServicoSolicitado? tipoServico,
  }) async {
    final models = await remoteDataSource.listarAbertasPorRegiao(
      cidade, 
      estado, 
      tipoServico: tipoServico,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> salvar(SolicitacaoEntity solicitacao) async {
    final model = SolicitacaoModel.fromEntity(solicitacao);
    await remoteDataSource.salvar(model);
  }

  @override
  Future<void> atualizarStatus(String solicitacaoId, StatusSolicitacao status) async {
    // Converte o Enum para String (status.name) ao repassar para a DataSource/Supabase
    await remoteDataSource.atualizarStatus(solicitacaoId, status.name);
  }
}