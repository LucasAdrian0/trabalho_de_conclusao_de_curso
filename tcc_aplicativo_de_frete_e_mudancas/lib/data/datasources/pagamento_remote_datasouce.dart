import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';
import '../models/pagamento_model.dart';

abstract class PagamentoRemoteDataSource {
  Future<PagamentoModel?> buscarPorServicoId(String servicoId);
  Future<void> registrar(PagamentoModel pagamento);
  Future<void> atualizarStatus(
    String pagamentoId,
    StatusPagamento status, {
    DateTime? dataConfirmacao,
  });
}

class PagamentoRemoteDataSourceImpl implements PagamentoRemoteDataSource {
  final SupabaseClient supabase;

  PagamentoRemoteDataSourceImpl({required this.supabase});

  @override
  Future<PagamentoModel?> buscarPorServicoId(String servicoId) async {
    final response = await supabase
        .from('pagamentos')
        .select()
        .eq('servico_id', servicoId)
        .maybeSingle();

    if (response == null) return null;
    return PagamentoModel.fromJson(response);
  }

  @override
  Future<void> registrar(PagamentoModel pagamento) async {
    await supabase.from('pagamentos').insert(pagamento.toJson());
  }

  @override
  Future<void> atualizarStatus(
    String pagamentoId,
    StatusPagamento status, {
    DateTime? dataConfirmacao,
  }) async {
    // Converte o Enum para String usando .name para salvar no banco
    final updateData = <String, dynamic>{'status': status.name};

    final dataFormatada = (dataConfirmacao ?? DateTime.now()).toIso8601String();

    if (status == StatusPagamento.aprovado) {
      updateData['aprovado_em'] = dataFormatada;
    }
    if (status == StatusPagamento.recusado) {
      updateData['recusado_em'] = dataFormatada;
    }
    if (status == StatusPagamento.estornado) {
      updateData['reembolsado_em'] = dataFormatada;
    }

    await supabase.from('pagamentos').update(updateData).eq('id', pagamentoId);
  }
}
