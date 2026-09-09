import '../../domain/entities/veiculo.dart';
import '../../domain/enums/status_veiculo.dart';
import '../../domain/repositories/veiculo_repository.dart';
import '../datasources/veiculo_remote_datasource.dart';
import '../models/veiculo_model.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final VeiculoRemoteDataSource remoteDataSource;

  VeiculoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Veiculo?> buscarPorId(String id) async {
    final model = await remoteDataSource.buscarPorId(id);
    return model?.toEntity();
  }

  @override
  Future<List<Veiculo>> listarPorPrestadorId(String prestadorId) async {
    final models = await remoteDataSource.listarPorPrestadorId(prestadorId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> salvar(Veiculo veiculo) async {
    final model = VeiculoModel.fromEntity(veiculo);
    await remoteDataSource.salvar(model);
  }

  @override
  Future<void> atualizarStatus(String veiculoId, StatusVeiculo status) async {
    await remoteDataSource.atualizarStatus(veiculoId, status);
  }

  @override
  Future<void> deletar(String veiculoId) async {
    await remoteDataSource.deletar(veiculoId);
  }
}