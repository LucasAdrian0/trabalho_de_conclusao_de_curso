import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  String? get usuarioId;
  Stream<String?> get alteracoesUsuario;
  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nome,
    required String tipo,
  });
  Future<void> entrar({required String email, required String senha});
  Future<void> sair();
  Future<void> recuperarSenha(String email, {String? redirectTo});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  AuthRemoteDataSourceImpl(this.client);
  @override
  String? get usuarioId => client.auth.currentUser?.id;
  @override
  Stream<String?> get alteracoesUsuario =>
      client.auth.onAuthStateChange.map((event) => event.session?.user.id);
  @override
  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nome,
    required String tipo,
  }) async {
    await client.auth.signUp(
      email: email,
      password: senha,
      data: {'nome': nome, 'tipo': tipo},
    );
  }

  @override
  Future<void> entrar({required String email, required String senha}) async {
    await client.auth.signInWithPassword(email: email, password: senha);
  }

  @override
  Future<void> sair() => client.auth.signOut();
  @override
  Future<void> recuperarSenha(String email, {String? redirectTo}) =>
      client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
}
