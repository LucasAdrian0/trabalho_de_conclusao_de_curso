import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/endereco_model.dart';

abstract class EnderecoRemoteDataSource {
  Future<List<EnderecoModel>> listar(String usuarioId);
  Future<EnderecoModel?> buscar(String id);
  Future<void> salvar(EnderecoModel endereco);
  Future<void> excluir(String id);
}

class EnderecoRemoteDataSourceImpl implements EnderecoRemoteDataSource {
  final SupabaseClient client;
  EnderecoRemoteDataSourceImpl(this.client);
  @override
  Future<List<EnderecoModel>> listar(String id) async =>
      (await client.from('enderecos').select().eq('usuario_id', id))
          .map(EnderecoModel.fromJson)
          .toList();
  @override
  Future<EnderecoModel?> buscar(String id) async {
    final j = await client
        .from('enderecos')
        .select()
        .eq('id', id)
        .maybeSingle();
    return j == null ? null : EnderecoModel.fromJson(j);
  }

  @override
  Future<void> salvar(EnderecoModel e) async {
    await client.from('enderecos').upsert(e.toJson());
  }

  @override
  Future<void> excluir(String id) async {
    await client.from('enderecos').delete().eq('id', id);
  }
}
