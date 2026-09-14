import '../../domain/repositories/auth_repository.dart';
import '../../domain/enums/tipo_usuario.dart';
import '../../domain/validation/credenciais.dart';

class CadastrarUsuario {
  final AuthRepository _auth;
  const CadastrarUsuario(this._auth);
  Future<void> call({
    required String email,
    required String senha,
    required String nome,
    required TipoUsuario tipo,
  }) async {
    final emailValido = Credenciais.email(email);
    final nomeValido = Credenciais.textoObrigatorio(nome, 'o nome');
    Credenciais.senhaCadastro(senha);
    await _auth.cadastrar(
      email: emailValido,
      senha: senha,
      nome: nomeValido,
      tipo: tipo,
    );
  }
}

class Entrar {
  final AuthRepository _auth;
  const Entrar(this._auth);
  Future<void> call({required String email, required String senha}) async {
    final emailValido = Credenciais.email(email);
    // Login não impõe a política de criação sobre senhas de contas existentes.
    Credenciais.textoObrigatorio(senha, 'a senha');
    await _auth.entrar(email: emailValido, senha: senha);
  }
}

class Sair {
  final AuthRepository _auth;
  const Sair(this._auth);
  Future<void> call() => _auth.sair();
}

class RecuperarSenha {
  final AuthRepository _auth;
  const RecuperarSenha(this._auth);
  Future<void> call(String email, {String? redirectTo}) async {
    await _auth.recuperarSenha(
      Credenciais.email(email),
      redirectTo: redirectTo,
    );
  }
}

class ObservarSessao {
  final AuthRepository _auth;
  const ObservarSessao(this._auth);
  Stream<String?> call() => _auth.alteracoesUsuario;
}
