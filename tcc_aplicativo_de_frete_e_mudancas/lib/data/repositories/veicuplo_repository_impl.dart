import '../errors/executar_repositorio.dart';
import '../../domain/entities/veiculo.dart';
import '../../domain/enums/status_veiculo.dart';
import '../../domain/repositories/veiculo_repository.dart';
import '../datasources/veiculo_remote_datasource.dart';
import '../models/veiculo_model.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final VeiculoRemoteDataSource remoteDataSource;

  VeiculoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Veiculo?> buscarPorId(String id) => executarRepositorio(() async {
    final model = await remoteDataSource.buscarPorId(id);
    return model?.toEntity();
  });

  @override
  Future<List<Veiculo>> listarPorPrestadorId(String prestadorId) =>
      executarRepositorio(() async {
        final models = await remoteDataSource.listarPorPrestadorId(prestadorId);
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<void> salvar(Veiculo veiculo) => executarRepositorio(() async {
    final model = VeiculoModel.fromEntity(veiculo);
    await remoteDataSource.salvar(model);
  });

  @override
  Future<void> atualizarStatus(String veiculoId, StatusVeiculo status) =>
      executarRepositorio(() async {
        await remoteDataSource.atualizarStatus(veiculoId, status);
      });

  @override
  Future<void> deletar(String veiculoId) => executarRepositorio(() async {
    await remoteDataSource.deletar(veiculoId);
  });
}
