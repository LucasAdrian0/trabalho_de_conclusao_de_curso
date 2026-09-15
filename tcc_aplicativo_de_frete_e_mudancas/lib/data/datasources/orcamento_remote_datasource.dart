import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/orcamento_model.dart';

abstract class OrcamentoRemoteDataSource {
  Future<OrcamentoModel> criar(OrcamentoModel orcamento);
  Future<List<OrcamentoModel>> gerarAutomaticos(String solicitacaoId);
  Future<List<OrcamentoModel>> listarSolicitacao(String id);
  Future<List<OrcamentoModel>> listarPrestador(String id);
  Future<OrcamentoModel> atualizarStatus(String id, String status);
}

class OrcamentoRemoteDataSourceImpl implements OrcamentoRemoteDataSource {
  final SupabaseClient client;
  OrcamentoRemoteDataSourceImpl(this.client);
  @override
  Future<OrcamentoModel> criar(OrcamentoModel o) async =>
      OrcamentoModel.fromJson(
        await client.from('orcamentos').insert(o.toJson()).select().single(),
      );
  @override
  Future<List<OrcamentoModel>> gerarAutomaticos(String solicitacaoId) async {
    final resposta = await client.rpc(
      'gerar_cotacoes_automaticas',
      params: {'p_solicitacao_id': solicitacaoId},
    );
    final orcamentos = (resposta as List<dynamic>)
        .map((json) => OrcamentoModel.fromJson(json as Map<String, dynamic>))
        .toList();
    orcamentos.sort((a, b) => a.valorTotal.compareTo(b.valorTotal));
    return orcamentos;
  }
  @override
  Future<List<OrcamentoModel>> listarSolicitacao(String id) async =>
      (await client
              .from('orcamentos')
              .select()
              .eq('solicitacao_id', id)
              .order('valor_total'))
          .map(OrcamentoModel.fromJson)
          .toList();
  @override
  Future<List<OrcamentoModel>> listarPrestador(String id) async =>
      (await client.from('orcamentos').select().eq('prestador_id', id))
          .map(OrcamentoModel.fromJson)
          .toList();
  @override
  Future<OrcamentoModel> atualizarStatus(String id, String status) async =>
      OrcamentoModel.fromJson(
        await client
            .from('orcamentos')
            .update({'status': status})
            .eq('id', id)
            .select()
            .single(),
      );
}
