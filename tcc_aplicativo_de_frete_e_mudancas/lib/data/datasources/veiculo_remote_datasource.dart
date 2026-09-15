import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/veiculo_model.dart';

abstract class VeiculoRemoteDataSource {
  Future<VeiculoModel?> buscar(String id);
  Future<List<VeiculoModel>> listar(String prestadorId);
  Future<void> salvar(VeiculoModel veiculo);
  Future<void> atualizarStatus(String id, String status);
  Future<void> excluir(String id);
}

class VeiculoRemoteDataSourceImpl implements VeiculoRemoteDataSource {
  final SupabaseClient client;
  VeiculoRemoteDataSourceImpl(this.client);
  @override
  Future<VeiculoModel?> buscar(String id) async {
    final j = await client.from('veiculos').select().eq('id', id).maybeSingle();
    return j == null ? null : VeiculoModel.fromJson(j);
  }

  @override
  Future<List<VeiculoModel>> listar(String id) async =>
      (await client.from('veiculos').select().eq('prestador_id', id))
          .map(VeiculoModel.fromJson)
          .toList();
  @override
  Future<void> salvar(VeiculoModel v) async {
    await client.from('veiculos').upsert(v.toJson());
  }

  @override
  Future<void> atualizarStatus(String id, String status) async {
    await client.from('veiculos').update({'status': status}).eq('id', id);
  }

  @override
  Future<void> excluir(String id) async {
    await client.from('veiculos').delete().eq('id', id);
  }
}
