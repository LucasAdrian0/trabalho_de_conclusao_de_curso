import '../mappers/database_enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/enums/status_servico.dart';
import '../models/servico_model.dart';

abstract class ServicoRemoteDataSource {
  Future<ServicoModel?> buscarPorId(String id);
  Future<List<ServicoModel>> listarPorClienteId(String clienteId);
  Future<List<ServicoModel>> listarPorPrestadorId(String prestadorId);
  Future<ServicoModel> aceitarOrcamento(String orcamentoId);
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus,
    String? observacao,
  });
}

class ServicoRemoteDataSourceImpl implements ServicoRemoteDataSource {
  final SupabaseClient supabase;

  ServicoRemoteDataSourceImpl({required this.supabase});

  static const String _selectQuery = '*, historico:historico_status_servico(*)';

  @override
  Future<ServicoModel?> buscarPorId(String id) async {
    final response = await supabase
        .from('servicos')
        .select(_selectQuery)
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return ServicoModel.fromJson(response);
  }

  @override
  Future<List<ServicoModel>> listarPorClienteId(String clienteId) async {
    final response = await supabase
        .from('servicos')
        .select(_selectQuery)
        .eq('cliente_id', clienteId);

    final lista = response as List;
    return lista
        .map((e) => ServicoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ServicoModel>> listarPorPrestadorId(String prestadorId) async {
    final response = await supabase
        .from('servicos')
        .select(_selectQuery)
        .eq('prestador_id', prestadorId);

    final lista = response as List;
    return lista
        .map((e) => ServicoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ServicoModel> aceitarOrcamento(String orcamentoId) async {
    final response = await supabase.rpc(
      'aceitar_orcamento',
      params: {'p_orcamento_id': orcamentoId},
    );
    return ServicoModel.fromJson(Map<String, dynamic>.from(response as Map));
  }

  @override
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus,
    String? observacao,
  }) async {
    await supabase.rpc(
      'atualizar_status_servico',
      params: {
        'p_servico_id': servicoId,
        'p_status': novoStatus.databaseValue,
        'p_observacao': observacao,
      },
    );
  }
}
