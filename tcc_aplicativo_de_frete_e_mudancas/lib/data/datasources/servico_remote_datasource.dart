import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/servico_model.dart';

abstract class ServicoRemoteDataSource {
  Future<ServicoModel?> buscar(String id);
  Future<List<ServicoModel>> listarPrestador(String id);
  Future<List<ServicoModel>> listarCliente(String id);
  Future<ServicoModel> aceitarOrcamento(String id);
  Future<void> atualizarStatus(String id, String status);
}

class ServicoRemoteDataSourceImpl implements ServicoRemoteDataSource {
  final SupabaseClient client;
  ServicoRemoteDataSourceImpl(this.client);
  static const selecao = '*,historico:historico_status(*)';
  @override
  Future<ServicoModel?> buscar(String id) async {
    final j = await client
        .from('servicos')
        .select(selecao)
        .eq('id', id)
        .maybeSingle();
    return j == null ? null : ServicoModel.fromJson(j);
  }

  @override
  Future<List<ServicoModel>> listarPrestador(String id) async =>
      (await client.from('servicos').select(selecao).eq('prestador_id', id))
          .map(ServicoModel.fromJson)
          .toList();
  @override
  Future<List<ServicoModel>> listarCliente(String id) async =>
      (await client
              .from('servicos')
              .select('$selecao,solicitacoes!inner(cliente_id)')
              .eq('solicitacoes.cliente_id', id))
          .map(ServicoModel.fromJson)
          .toList();
  @override
  Future<ServicoModel> aceitarOrcamento(String id) async =>
      ServicoModel.fromJson(
        Map<String, dynamic>.from(
          await client.rpc('aceitar_orcamento', params: {'p_orcamento_id': id}),
        ),
      );
  @override
  Future<void> atualizarStatus(String id, String status) async {
    await client.rpc(
      'atualizar_status_servico',
      params: {'p_servico_id': id, 'p_status': status},
    );
  }
}
