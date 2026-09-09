import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/orcamento_model.dart';

abstract class OrcamentoRemoteDataSource {
  Future<OrcamentoModel> criar(OrcamentoModel model);
  Future<List<OrcamentoModel>> buscarPorFrete(String freteId);
  Future<List<OrcamentoModel>> buscarPorPrestador(String prestadorId);
  Future<OrcamentoModel> atualizarStatus(String id, String statusName);
}

class OrcamentoRemoteDataSourceImpl implements OrcamentoRemoteDataSource {
  final SupabaseClient _client;

  OrcamentoRemoteDataSourceImpl(this._client);

  static const String _table = 'orcamentos';

  @override
  Future<OrcamentoModel> criar(OrcamentoModel model) async {
    final response = await _client
        .from(_table)
        .insert(model.toJson())
        .select()
        .single();

    return OrcamentoModel.fromJson(response);
  }

  @override
  Future<List<OrcamentoModel>> buscarPorFrete(String freteId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('frete_id', freteId)
        .order('criado_em', ascending: false);

    return (response as List)
        .map((e) => OrcamentoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<OrcamentoModel>> buscarPorPrestador(String prestadorId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('prestador_id', prestadorId)
        .order('criado_em', ascending: false);

    return (response as List)
        .map((e) => OrcamentoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<OrcamentoModel> atualizarStatus(String id, String statusName) async {
    final response = await _client
        .from(_table)
        .update({
          'status': statusName,
          'atualizado_em': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .select()
        .single();

    return OrcamentoModel.fromJson(response);
  }
}
