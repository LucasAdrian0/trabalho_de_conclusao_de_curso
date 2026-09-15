import '../entities/usuario_entity.dart';

abstract class UsuarioRepository {
  Future<UsuarioEntity?> buscarPorId(String id);
  Future<void> atualizar(UsuarioEntity usuario);
  Future<void> desativar(String id);
}
