import '../../domain/entities/cliente_entity.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../models/cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource dataSource;
  ClienteRepositoryImpl(this.dataSource);

  @override
  Future<ClienteEntity?> buscarPorUsuarioId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<void> salvar(ClienteEntity cliente) => executarRepositorio(
    () => dataSource.salvar(ClienteModel.fromEntity(cliente)),
  );
}
