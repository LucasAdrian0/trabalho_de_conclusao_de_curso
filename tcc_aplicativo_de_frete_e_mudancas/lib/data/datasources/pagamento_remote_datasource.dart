import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pagamento_model.dart';

abstract class PagamentoRemoteDataSource {
  Future<PagamentoModel?> buscar(String servicoId);
}

class PagamentoRemoteDataSourceImpl implements PagamentoRemoteDataSource {
  final SupabaseClient client;
  PagamentoRemoteDataSourceImpl(this.client);
  @override
  Future<PagamentoModel?> buscar(String id) async {
    final j = await client
        .from('pagamentos')
        .select()
        .eq('servico_id', id)
        .order('criado_em', ascending: false)
        .limit(1)
        .maybeSingle();
    return j == null ? null : PagamentoModel.fromJson(j);
  }
}
