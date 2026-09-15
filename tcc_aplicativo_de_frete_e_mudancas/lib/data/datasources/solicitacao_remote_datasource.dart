import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/endereco_model.dart';
import '../models/item_mudanca_model.dart';
import '../models/solicitacao_model.dart';

abstract class SolicitacaoRemoteDataSource {
  Future<SolicitacaoModel?> buscar(String id);
  Future<List<SolicitacaoModel>> listarCliente(String clienteId);
  Future<List<SolicitacaoModel>> listarAbertas();
  Future<void> criar(SolicitacaoModel solicitacao);
  Future<void> atualizarStatus(String id, String status);
}

class SolicitacaoRemoteDataSourceImpl implements SolicitacaoRemoteDataSource {
  final SupabaseClient client;
  SolicitacaoRemoteDataSourceImpl(this.client);
  static const selecao =
      '*,endereco_origem:enderecos!endereco_origem_id(*),endereco_destino:enderecos!endereco_destino_id(*),itens:itens_mudanca(*)';
  @override
  Future<SolicitacaoModel?> buscar(String id) async {
    final j = await client
        .from('solicitacoes')
        .select(selecao)
        .eq('id', id)
        .maybeSingle();
    return j == null ? null : SolicitacaoModel.fromJson(j);
  }

  @override
  Future<List<SolicitacaoModel>> listarCliente(String id) async =>
      (await client.from('solicitacoes').select(selecao).eq('cliente_id', id))
          .map(SolicitacaoModel.fromJson)
          .toList();
  @override
  Future<List<SolicitacaoModel>> listarAbertas() async =>
      (await client
              .from('solicitacoes')
              .select(selecao)
              .eq('status', 'aguardando_prestador'))
          .map(SolicitacaoModel.fromJson)
          .toList();
  @override
  Future<void> criar(SolicitacaoModel s) async {
    await client.rpc(
      'criar_solicitacao_com_itens',
      params: {
        'p_solicitacao': s.toJson(),
        'p_origem': EnderecoModel.fromEntity(s.enderecoOrigem).toJson(),
        'p_destino': EnderecoModel.fromEntity(s.enderecoDestino).toJson(),
        'p_itens': s.itens
            .map((e) => ItemMudancaModel.fromEntity(e).toJson())
            .toList(),
      },
    );
  }

  @override
  Future<void> atualizarStatus(String id, String status) async {
    await client.rpc(
      'atualizar_status_solicitacao',
      params: {'p_solicitacao_id': id, 'p_status': status},
    );
  }
}
