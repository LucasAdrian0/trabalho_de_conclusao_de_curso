import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_model.dart';

abstract class ClienteRemoteDataSource {
  Future<ClienteModel?> buscarPorUsuarioId(String usuarioId);
  Future<ClienteModel?> buscarPorCpf(String cpf);
  Future<void> salvar(ClienteModel cliente);
  Future<void> atualizar(ClienteModel cliente);
}

class ClienteRemoteDataSourceImpl implements ClienteRemoteDataSource {
  final SupabaseClient supabase;

  ClienteRemoteDataSourceImpl({required this.supabase});

  @override
  Future<ClienteModel?> buscarPorUsuarioId(String usuarioId) async {
    final response = await supabase
        .from('clientes')
        .select(
          '*, usuarios(id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at)',
        )
        .eq('usuario_id', usuarioId)
        .maybeSingle();

    if (response == null) return null;
    return ClienteModel.fromJson(response);
  }

  @override
  Future<ClienteModel?> buscarPorCpf(String cpf) async {
    final response = await supabase
        .from('clientes')
        .select(
          '*, usuarios(id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at)',
        )
        .eq('cpf', cpf)
        .maybeSingle();

    if (response == null) return null;
    return ClienteModel.fromJson(response);
  }

  @override
  Future<void> salvar(ClienteModel cliente) async {
    await supabase.from('clientes').upsert(cliente.toJson());
  }

  @override
  Future<void> atualizar(ClienteModel cliente) async {
    await supabase
        .from('clientes')
        .update(cliente.toJson())
        .eq('usuario_id', cliente.usuario.id);
  }
}
