import '../../domain/entities/servico_entity.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/repositories/servico_repository.dart';
import '../datasources/servico_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';

class ServicoRepositoryImpl implements ServicoRepository {
  final ServicoRemoteDataSource dataSource;
  ServicoRepositoryImpl(this.dataSource);

  @override
  Future<ServicoEntity?> buscarPorId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<List<ServicoEntity>> listarPorClienteId(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarCliente(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<List<ServicoEntity>> listarPorPrestadorId(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarPrestador(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<ServicoEntity> aceitarOrcamento(String id) => executarRepositorio(
    () async => (await dataSource.aceitarOrcamento(id)).toEntity(),
  );
  @override
  Future<void> atualizarStatus(String id, StatusSolicitacao status) =>
      executarRepositorio(
        () => dataSource.atualizarStatus(id, status.databaseValue),
      );
}
