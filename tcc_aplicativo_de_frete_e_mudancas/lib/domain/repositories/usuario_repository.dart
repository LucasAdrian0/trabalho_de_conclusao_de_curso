
abstract class UsuarioRepository {
  Future<void> validarEmail(String email);
  Future<void> validarSenha(String senha);

} 