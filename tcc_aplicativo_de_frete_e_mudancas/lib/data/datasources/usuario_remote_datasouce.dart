import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario_model.dart';

abstract class UsuarioRemoteDataSource {
  Future<UsuarioModel?> buscarPorId(String id);
  Future<UsuarioModel?> buscarPorEmail(String email);
  Future<void> salvar(UsuarioModel usuario);
  Future<void> atualizar(UsuarioModel usuario);
  Future<void> desativar(String id);
}

class UsuarioRemoteDataSourceImpl implements UsuarioRemoteDataSource {
  final SupabaseClient supabase;

  UsuarioRemoteDataSourceImpl({required this.supabase});

  @override
  Future<UsuarioModel?> buscarPorId(String id) async {
    final response = await supabase
        .from('usuarios')
        .select(
          'id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at',
        )
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return UsuarioModel.fromJson(response);
  }

  @override
  Future<UsuarioModel?> buscarPorEmail(String email) async {
    final response = await supabase
        .from('usuarios')
        .select(
          'id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at',
        )
        .eq('email', email)
        .maybeSingle();

    if (response == null) return null;
    return UsuarioModel.fromJson(response);
  }

  @override
  Future<void> salvar(UsuarioModel usuario) async {
    // O perfil é criado pelo trigger do Supabase Auth.
    await atualizar(usuario);
  }

  @override
  Future<void> atualizar(UsuarioModel usuario) async {
    await supabase
        .from('usuarios')
        .update({
          'nome': usuario.nome,
          'telefone': usuario.telefone,
          'foto_url': usuario.fotoUrl,
        })
        .eq('id', usuario.id)
        .select('id')
        .single();
  }

  @override
  Future<void> desativar(String id) async {
    await supabase.from('usuarios').update({'ativo': false}).eq('id', id);
  }
}
