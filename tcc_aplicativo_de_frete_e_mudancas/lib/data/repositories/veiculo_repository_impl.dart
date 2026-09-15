import '../../domain/entities/veiculo.dart';
import '../../domain/enums/status_veiculo.dart';
import '../../domain/repositories/veiculo_repository.dart';
import '../datasources/veiculo_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';
import '../models/veiculo_model.dart';

class VeiculoRepositoryImpl implements VeiculoRepository {
  final VeiculoRemoteDataSource dataSource;
  VeiculoRepositoryImpl(this.dataSource);

  @override
  Future<Veiculo?> buscarPorId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<List<Veiculo>> listarPorPrestadorId(String id) => executarRepositorio(
    () async => (await dataSource.listar(id)).map((m) => m.toEntity()).toList(),
  );
  @override
  Future<void> salvar(Veiculo veiculo) => executarRepositorio(
    () => dataSource.salvar(VeiculoModel.fromEntity(veiculo)),
  );
  @override
  Future<void> atualizarStatus(String id, StatusVeiculo status) =>
      executarRepositorio(
        () => dataSource.atualizarStatus(id, status.databaseValue),
      );
  @override
  Future<void> excluir(String id) =>
      executarRepositorio(() => dataSource.excluir(id));
}
