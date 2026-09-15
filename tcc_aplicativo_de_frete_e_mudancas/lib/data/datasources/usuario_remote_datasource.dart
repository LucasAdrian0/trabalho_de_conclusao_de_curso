import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario_model.dart';

abstract class UsuarioRemoteDataSource {
  Future<UsuarioModel?> buscarPorId(String id);
  Future<void> atualizar(UsuarioModel usuario);
  Future<void> desativar(String id);
}

class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDataSource {
  final SupabaseClient client;
  UsuarioRemoteDataSourceImpl(this.client);
  static const colunas =
      'id,tipo,nome,email,telefone,foto_perfil_url,ativo,criado_em,atualizado_em';
  @override
  Future<UsuarioModel?> buscarPorId(String id) async {
    final j = await client
        .from('usuarios')
        .select(colunas)
        .eq('id', id)
        .maybeSingle();
    return j == null ? null : UsuarioModel.fromJson(j);
  }

  @override
  Future<void> atualizar(UsuarioModel u) async {
    await client
        .from('usuarios')
        .update({
          'nome': u.nome,
          'telefone': u.telefone,
          'foto_perfil_url': u.fotoPerfilUrl,
        })
        .eq('id', u.id);
  }

  @override
  Future<void> desativar(String id) async {
    await client.from('usuarios').update({'ativo': false}).eq('id', id);
  }
}
