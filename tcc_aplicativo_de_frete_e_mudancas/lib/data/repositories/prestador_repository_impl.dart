import '../../domain/entities/prestador_entity.dart';
import '../../domain/enums/status_disponibilidade.dart';
import '../../domain/repositories/prestador_repository.dart';
import '../datasources/prestador_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';
import '../models/prestador_model.dart';

class PrestadorRepositoryImpl implements PrestadorRepository {
  final PrestadorRemoteDataSource dataSource;
  PrestadorRepositoryImpl(this.dataSource);

  @override
  Future<PrestadorEntity?> buscarPorUsuarioId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<List<PrestadorEntity>> listarDisponiveis(String regiao) =>
      executarRepositorio(
        () async => (await dataSource.listarDisponiveis(
          regiao,
        )).map((model) => model.toEntity()).toList(),
      );
  @override
  Future<void> salvar(PrestadorEntity prestador) => executarRepositorio(
    () => dataSource.salvar(PrestadorModel.fromEntity(prestador)),
  );
  @override
  Future<void> alterarDisponibilidade(
    String id,
    StatusDisponibilidade status,
  ) => executarRepositorio(
    () => dataSource.atualizarDisponibilidade(id, status.databaseValue),
  );
}
