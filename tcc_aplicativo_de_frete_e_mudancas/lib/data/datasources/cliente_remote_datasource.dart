import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cliente_model.dart';
import 'usuario_remote_datasource.dart';

abstract class ClienteRemoteDataSource {
  Future<ClienteModel?> buscar(String usuarioId);
  Future<void> salvar(ClienteModel cliente);
}

class ClienteRemoteDataSourceImpl implements ClienteRemoteDataSource {
  final SupabaseClient client;
  ClienteRemoteDataSourceImpl(this.client);
  @override
  Future<ClienteModel?> buscar(String id) async {
    final j = await client
        .from('clientes')
        .select('cpf,usuarios(${UsuarioRemoteDataSourceImpl.colunas})')
        .eq('usuario_id', id)
        .maybeSingle();
    return j == null ? null : ClienteModel.fromJson(j);
  }

  @override
  Future<void> salvar(ClienteModel c) async {
    await client.from('clientes').upsert(c.toJson());
  }
}
