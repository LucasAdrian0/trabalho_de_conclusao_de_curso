import '../mappers/database_enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/enums/tipo_servico_solicitado.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../models/endereco_model.dart';
import '../models/item_solicitado.dart';
import '../models/solicitacao_model.dart';

abstract class SolicitacaoRemoteDataSource {
  Future<SolicitacaoModel?> buscarPorId(String id);
  Future<List<SolicitacaoModel>> listarPorClienteId(String clienteId);
  Future<List<SolicitacaoModel>> listarAbertasPorRegiao(
    String cidade,
    String estado, {
    TipoServicoSolicitado? tipoServico,
  });
  Future<void> salvar(SolicitacaoModel solicitacao);
  Future<void> atualizarStatus(String solicitacaoId, String status);
}

class SolicitacaoRemoteDataSourceImpl implements SolicitacaoRemoteDataSource {
  final SupabaseClient supabase;

  SolicitacaoRemoteDataSourceImpl({required this.supabase});

  static const String _selectQuery =
      '*, endereco_origem:enderecos!endereco_origem_id(*), endereco_destino:enderecos!endereco_destino_id(*), itens:itens_solicitacao(*)';

  @override
  Future<SolicitacaoModel?> buscarPorId(String id) async {
    final response = await supabase
        .from('solicitacoes')
        .select(_selectQuery)
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return SolicitacaoModel.fromJson(response);
  }

  @override
  Future<List<SolicitacaoModel>> listarPorClienteId(String clienteId) async {
    final response = await supabase
        .from('solicitacoes')
        .select(_selectQuery)
        .eq('cliente_id', clienteId);

    final lista = response as List;
    return lista
        .map((e) => SolicitacaoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SolicitacaoModel>> listarAbertasPorRegiao(
    String cidade,
    String estado, {
    TipoServicoSolicitado? tipoServico,
  }) async {
    var query = supabase
        .from('solicitacoes')
        .select(
          _selectQuery.replaceAll(
            '!endereco_origem_id(*)',
            '!endereco_origem_id!inner(*)',
          ),
        )
        .eq('status', StatusSolicitacao.aguardandoPrestador.databaseValue)
        .eq('endereco_origem.cidade', cidade)
        .eq('endereco_origem.estado', estado);

    // Filtra pelo enum caso seja passado
    if (tipoServico != null) {
      query = query.eq('tipo_servico', tipoServico.databaseValue);
    }

    final response = await query;
    final lista = response as List;
    return lista
        .map((e) => SolicitacaoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> salvar(SolicitacaoModel solicitacao) async {
    await supabase.rpc(
      'criar_solicitacao_com_itens',
      params: {
        'p_solicitacao': solicitacao.toJson(),
        'p_origem': EnderecoModel.fromEntity(
          solicitacao.enderecoOrigem,
        ).toJson(),
        'p_destino': EnderecoModel.fromEntity(
          solicitacao.enderecoDestino,
        ).toJson(),
        'p_itens': solicitacao.itens
            .map((item) => ItemSolicitacaoModel.fromEntity(item).toJson())
            .toList(),
      },
    );
  }

  @override
  Future<void> atualizarStatus(String solicitacaoId, String status) async {
    await supabase.rpc(
      'atualizar_status_solicitacao',
      params: {'p_solicitacao_id': solicitacaoId, 'p_status': status},
    );
  }
}
