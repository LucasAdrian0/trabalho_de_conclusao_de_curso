import '../../domain/entities/avaliacao_entity.dart';
import '../../domain/repositories/avaliacao_repository.dart';
import '../datasources/avaliacao_remote_datasource.dart';
import '../models/avaliacao_model.dart';

class AvaliacaoRepositoryImpl implements AvaliacaoRepository {
  final AvaliacaoRemoteDataSource remoteDataSource;

  AvaliacaoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> salvar(AvaliacaoEntity avaliacao) async {
    final model = AvaliacaoModel.fromEntity(avaliacao);
    await remoteDataSource.salvar(model);
  }

  @override
  Future<List<AvaliacaoEntity>> listarPorPrestadorId(String prestadorId) async {
    final models = await remoteDataSource.listarPorPrestadorId(prestadorId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AvaliacaoEntity?> buscarPorServicoId(String servicoId) async {
    final model = await remoteDataSource.buscarPorServicoId(servicoId);
    return model?.toEntity();
  }
}
