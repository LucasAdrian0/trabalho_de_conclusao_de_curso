import '../../domain/enums/tipo_usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  String? get usuarioId => remoteDataSource.usuarioId;
  @override
  Stream<String?> get alteracoesUsuario =>
      protegerStream(remoteDataSource.alteracoesUsuario);
  @override
  Future<void> cadastrar({
    required String email,
    required String senha,
    required String nome,
    required TipoUsuario tipo,
  }) => executarRepositorio(
    () => remoteDataSource.cadastrar(
      email: email,
      senha: senha,
      nome: nome,
      tipo: tipo.databaseValue,
    ),
  );
  @override
  Future<void> entrar({required String email, required String senha}) =>
      executarRepositorio(
        () => remoteDataSource.entrar(email: email, senha: senha),
      );
  @override
  Future<void> sair() => executarRepositorio(remoteDataSource.sair);
  @override
  Future<void> recuperarSenha(String email, {String? redirectTo}) =>
      executarRepositorio(
        () => remoteDataSource.recuperarSenha(email, redirectTo: redirectTo),
      );
}
