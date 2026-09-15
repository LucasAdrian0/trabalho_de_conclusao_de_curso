import '../../domain/entities/ajudante_entity.dart';
import '../../domain/repositories/ajudante_repository.dart';
import '../datasources/ajudante_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../models/ajudante_model.dart';

class AjudanteRepositoryImpl implements AjudanteRepository {
  final AjudanteRemoteDataSource dataSource;
  AjudanteRepositoryImpl(this.dataSource);

  @override
  Future<List<AjudanteEntity>> listarPorPrestadorId(String id) =>
      executarRepositorio(
        () async =>
            (await dataSource.listar(id)).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<void> salvar(AjudanteEntity ajudante) => executarRepositorio(
    () => dataSource.salvar(AjudanteModel.fromEntity(ajudante)),
  );
  @override
  Future<void> excluir(String id) =>
      executarRepositorio(() => dataSource.excluir(id));
}
