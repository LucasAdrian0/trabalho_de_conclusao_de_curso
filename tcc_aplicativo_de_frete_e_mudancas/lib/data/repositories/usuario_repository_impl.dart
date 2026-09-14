import '../errors/executar_repositorio.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../datasources/usuario_remote_datasouce.dart';
import '../models/usuario_model.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;
  UsuarioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UsuarioEntity?> buscarPorId(String id) =>
      executarRepositorio(() async {
        return (await remoteDataSource.buscarPorId(id))?.toEntity();
      });
  @override
  Future<UsuarioEntity?> buscarPorEmail(String email) =>
      executarRepositorio(() async {
        return (await remoteDataSource.buscarPorEmail(email))?.toEntity();
      });
  @override
  Future<void> salvar(UsuarioEntity usuario) => executarRepositorio(() async {
    return remoteDataSource.salvar(UsuarioModel.fromEntity(usuario));
  });
  @override
  Future<void> atualizar(UsuarioEntity usuario) =>
      executarRepositorio(() async {
        return remoteDataSource.atualizar(UsuarioModel.fromEntity(usuario));
      });
  @override
  Future<void> desativar(String id) => executarRepositorio(() async {
    return remoteDataSource.desativar(id);
  });
}
