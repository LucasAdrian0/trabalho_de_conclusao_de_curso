import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/enums/tipo_servico_solicitado.dart';
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
      '*, endereco_origem:enderecos!origem_id(*), endereco_destino:enderecos!destino_id(*), itens:itens_solicitacao(*)';

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
    return lista.map((e) => SolicitacaoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<SolicitacaoModel>> listarAbertasPorRegiao(
    String cidade, 
    String estado, {
    TipoServicoSolicitado? tipoServico,
  }) async {
    var query = supabase
        .from('solicitacoes')
        .select(_selectQuery)
        .eq('status', 'aguardando_prestador') // Mantendo padrão do banco
        .eq('endereco_origem.cidade', cidade)
        .eq('endereco_origem.estado', estado);

    // Filtra pelo enum caso seja passado
    if (tipoServico != null) {
      query = query.eq('tipo_servico', tipoServico.name);
    }

    final response = await query;
    final lista = response as List;
    return lista.map((e) => SolicitacaoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> salvar(SolicitacaoModel solicitacao) async {
    await supabase.from('solicitacoes').insert(solicitacao.toJson());
  }

  @override
  Future<void> atualizarStatus(String solicitacaoId, String status) async {
    await supabase
        .from('solicitacoes')
        .update({'status': status})
        .eq('id', solicitacaoId);
  }
}