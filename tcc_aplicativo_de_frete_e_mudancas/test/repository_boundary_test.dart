import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_frete_urbano/data/datasources/auth_remote_datasource.dart';
import 'package:tcc_frete_urbano/data/datasources/usuario_remote_datasouce.dart';
import 'package:tcc_frete_urbano/data/repositories/auth_repository_impl.dart';
import 'package:tcc_frete_urbano/data/repositories/usuario_repository_impl.dart';
import 'package:tcc_frete_urbano/data/models/usuario_model.dart';
import 'package:tcc_frete_urbano/data/models/cliente_model.dart';
import 'package:tcc_frete_urbano/domain/entities/usuario_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/cliente_entity.dart';
import 'package:tcc_frete_urbano/domain/errors/falha.dart';

class AuthDataSourceFake implements AuthRemoteDataSource {
  Object erro = const AuthException('Mensagem interna do provedor');
  @override
  Future<void> entrar({required String email, required String senha}) async => throw erro;
  @override
  Stream<String?> get alteracoesUsuario => Stream<String?>.error(erro);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class UsuarioDataSourceFake implements UsuarioRemoteDataSource {
  Object? erro;
  @override
  Future<UsuarioModel?> buscarPorId(String id) async {
    if (erro != null) throw erro!;
    return UsuarioModel.fromJson(usuarioJson);
  }
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
const usuarioJson = {
  'id': 'u', 'tipo': 'cliente', 'nome': 'Ana', 'email': 'ana@example.com',
  'created_at': '2026-09-13T12:00:00Z', 'updated_at': '2026-09-13T12:00:00Z',
};

TypeMatcher<Falha> tipoFalha(TipoFalha tipo) => 
    isA<Falha>().having((e) => e.tipo, 'tipo', tipo);

void main() {
  test('Erro de Auth vira erro de domínio sem mensagem interna', () async {
    final repo = AuthRepositoryImpl(remoteDataSource: AuthDataSourceFake());
    
    await expectLater(
      repo.entrar(email: 'a@example.com', senha: '12345678'), 
      throwsA(
        // 2. Agora você pode encadear o .having() sem precisar de cast manual no "e"
        tipoFalha(TipoFalha.naoAutenticado)
            .having((e) => e.mensagem, 'mensagem', isNot(contains('Mensagem interna'))),
      ),
    );
  });
  test('Timeout vira indisponibilidade de domínio', () async {
    final repo = AuthRepositoryImpl(remoteDataSource: AuthDataSourceFake()..erro = TimeoutException('timeout técnico'));
    await expectLater(repo.entrar(email: 'a@example.com', senha: '12345678'), throwsA(tipoFalha(TipoFalha.indisponivel)));
  });
  test('Stream de sessão também converte erros de infraestrutura', () async {
    final repo = AuthRepositoryImpl(remoteDataSource: AuthDataSourceFake());
    await expectLater(repo.alteracoesUsuario, emitsError(tipoFalha(TipoFalha.naoAutenticado)));
  });
  test('Repositório retorna entidade pura, sem model de persistência', () async {
    final usuario = await UsuarioRepositoryImpl(remoteDataSource: UsuarioDataSourceFake()).buscarPorId('u');
    expect(usuario, isA<UsuarioEntity>());
    expect(usuario, isNot(isA<UsuarioModel>()));
  });
  test('Conversão de agregado não deixa model no usuário aninhado', () {
    final cliente = ClienteModel.fromJson({'usuarios': usuarioJson, 'cpf': '52998224725'}).toEntity();
    expect(cliente, isA<ClienteEntity>());
    expect(cliente, isNot(isA<ClienteModel>()));
    expect(cliente.usuario, isNot(isA<UsuarioModel>()));
  });
  test('Violação de unicidade vira conflito de domínio', () async {
    final ds = UsuarioDataSourceFake()..erro = const PostgrestException(message: 'constraint privada', code: '23505');
    await expectLater(UsuarioRepositoryImpl(remoteDataSource: ds).buscarPorId('u'), throwsA(tipoFalha(TipoFalha.conflito)));
  });
}
