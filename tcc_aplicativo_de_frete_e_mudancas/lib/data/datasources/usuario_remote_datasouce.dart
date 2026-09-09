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
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return UsuarioModel.fromJson(response);
  }

  @override
  Future<UsuarioModel?> buscarPorEmail(String email) async {
    final response = await supabase
        .from('usuarios')
        .select()
        .eq('email', email)
        .maybeSingle();

    if (response == null) return null;
    return UsuarioModel.fromJson(response);
  }

  @override
  Future<void> salvar(UsuarioModel usuario) async {
    await supabase.from('usuarios').insert(usuario.toJson());
  }

  @override
  Future<void> atualizar(UsuarioModel usuario) async {
    await supabase
        .from('usuarios')
        .update(usuario.toJson())
        .eq('id', usuario.id);
  }

  @override
  Future<void> desativar(String id) async {
    await supabase.from('usuarios').update({'ativo': false}).eq('id', id);
  }
}