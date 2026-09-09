import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/endereco_model.dart';

abstract class EnderecoRemoteDataSource {
  Future<List<EnderecoModel>> listarPorUsuarioId(String usuarioId);
  Future<EnderecoModel?> buscarPorId(String id);
  Future<void> salvar(EnderecoModel endereco);
  Future<void> atualizar(EnderecoModel endereco);
  Future<void> deletar(String id);
}

class EnderecoRemoteDataSourceImpl implements EnderecoRemoteDataSource {
  final SupabaseClient supabase;

  EnderecoRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<EnderecoModel>> listarPorUsuarioId(String usuarioId) async {
    final response = await supabase
        .from('enderecos')
        .select()
        .eq('usuario_id', usuarioId);

    final lista = response as List;
    return lista.map((e) => EnderecoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<EnderecoModel?> buscarPorId(String id) async {
    final response = await supabase
        .from('enderecos')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return EnderecoModel.fromJson(response);
  }

  @override
  Future<void> salvar(EnderecoModel endereco) async {
    await supabase.from('enderecos').insert(endereco.toJson());
  }

  @override
  Future<void> atualizar(EnderecoModel endereco) async {
    await supabase
        .from('enderecos')
        .update(endereco.toJson())
        .eq('id', endereco.id);
  }

  @override
  Future<void> deletar(String id) async {
    await supabase.from('enderecos').delete().eq('id', id);
  }
}