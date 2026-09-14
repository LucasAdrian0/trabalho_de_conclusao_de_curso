import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pagamento_model.dart';

abstract class PagamentoRemoteDataSource {
  Future<PagamentoModel?> buscarPorServicoId(String servicoId);
}

class PagamentoRemoteDataSourceImpl implements PagamentoRemoteDataSource {
  final SupabaseClient supabase;
  PagamentoRemoteDataSourceImpl({required this.supabase});
  @override
  Future<PagamentoModel?> buscarPorServicoId(String servicoId) async {
    final response = await supabase
        .from('pagamentos')
        .select('*, servicos(cliente_id)')
        .eq('servico_id', servicoId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return response == null ? null : PagamentoModel.fromJson(response);
  }
}
