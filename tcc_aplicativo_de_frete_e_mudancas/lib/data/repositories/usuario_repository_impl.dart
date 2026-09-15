import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../models/usuario_model.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource dataSource;
  UsuarioRepositoryImpl(this.dataSource);

  @override
  Future<UsuarioEntity?> buscarPorId(String id) => executarRepositorio(
    () async => (await dataSource.buscarPorId(id))?.toEntity(),
  );
  @override
  Future<void> atualizar(UsuarioEntity usuario) => executarRepositorio(
    () => dataSource.atualizar(UsuarioModel.fromEntity(usuario)),
  );
  @override
  Future<void> desativar(String id) =>
      executarRepositorio(() => dataSource.desativar(id));
}
