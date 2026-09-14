import '../enums/tipo_usuario.dart';

abstract class AuthRepository {
  String? get usuarioId;
  Stream<String?> get alteracoesUsuario;

  /// O cadastro pode exigir confirmação por e-mail antes de haver sessão.
  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nome,
    required TipoUsuario tipo,
  });
  Future<void> entrar({required String email, required String senha});
  Future<void> sair();
  Future<void> recuperarSenha(String email, {String? redirectTo});
}
