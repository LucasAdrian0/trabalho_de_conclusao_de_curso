import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/enums/status_servico.dart';
import '../models/servico_model.dart';

abstract class ServicoRemoteDataSource {
  Future<ServicoModel?> buscarPorId(String id);
  Future<List<ServicoModel>> listarPorClienteId(String clienteId);
  Future<List<ServicoModel>> listarPorPrestadorId(String prestadorId);
  Future<void> criar(ServicoModel servico);
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus,
    required String usuarioId,
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
    return lista.map((e) => ServicoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<ServicoModel>> listarPorPrestadorId(String prestadorId) async {
    final response = await supabase
        .from('servicos')
        .select(_selectQuery)
        .eq('prestador_id', prestadorId);

    final lista = response as List;
    return lista.map((e) => ServicoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> criar(ServicoModel servico) async {
    await supabase.from('servicos').insert(servico.toJson());
  }

  @override
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus,
    required String usuarioId,
    String? observacao,
  }) async {
    await supabase
        .from('servicos')
        .update({'status': novoStatus.name})
        .eq('id', servicoId);

    await supabase.from('historico_status_servico').insert({
  'servico_id': servicoId,
  'status_novo': novoStatus.name,
  'alterado_por_usuario_id': usuarioId,
  'observacao': observacao,
});
  }
}