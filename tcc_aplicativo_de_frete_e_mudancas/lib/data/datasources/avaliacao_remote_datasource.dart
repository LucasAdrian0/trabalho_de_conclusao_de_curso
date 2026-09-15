import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/avaliacao_model.dart';

abstract class AvaliacaoRemoteDataSource {
  Future<void> salvar(AvaliacaoModel avaliacao);
  Future<List<AvaliacaoModel>> listarPrestador(String id);
  Future<AvaliacaoModel?> buscarServico(String id);
}

class AvaliacaoRemoteDataSourceImpl implements AvaliacaoRemoteDataSource {
  final SupabaseClient client;
  AvaliacaoRemoteDataSourceImpl(this.client);
  @override
  Future<void> salvar(AvaliacaoModel a) async {
    await client.from('avaliacoes').insert(a.toJson());
  }

  @override
  Future<List<AvaliacaoModel>> listarPrestador(String id) async =>
      (await client.from('avaliacoes').select().eq('prestador_id', id))
          .map(AvaliacaoModel.fromJson)
          .toList();
  @override
  Future<AvaliacaoModel?> buscarServico(String id) async {
    final j = await client
        .from('avaliacoes')
        .select()
        .eq('servico_id', id)
        .maybeSingle();
    return j == null ? null : AvaliacaoModel.fromJson(j);
  }
}
