import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/avaliacao_model.dart';

abstract class AvaliacaoRemoteDataSource {
  Future<void> salvar(AvaliacaoModel avaliacao);
  Future<List<AvaliacaoModel>> listarPorPrestadorId(String prestadorId);
  Future<AvaliacaoModel?> buscarPorServicoId(String servicoId);
}

class AvaliacaoRemoteDataSourceImpl implements AvaliacaoRemoteDataSource {
  final SupabaseClient supabase;

  AvaliacaoRemoteDataSourceImpl({required this.supabase});

  @override
  Future<void> salvar(AvaliacaoModel avaliacao) async {
    await supabase.from('avaliacoes').insert(avaliacao.toJson());
  }

  @override
  Future<List<AvaliacaoModel>> listarPorPrestadorId(String prestadorId) async {
    final response = await supabase
        .from('avaliacoes')
        .select()
        .eq('prestador_id', prestadorId);

    final lista = response as List;
    return lista
        .map((e) => AvaliacaoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AvaliacaoModel?> buscarPorServicoId(String servicoId) async {
    final response = await supabase
        .from('avaliacoes')
        .select()
        .eq('servico_id', servicoId)
        .maybeSingle();

    if (response == null) return null;
    return AvaliacaoModel.fromJson(response);
  }
}
