import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';

import '../entities/pagamento_entity.dart';

abstract class PagamentoRepository {
  Future<PagamentoEntity?> buscarPorServicoId(String servicoId);
  Future<void> registrar(PagamentoEntity pagamento);
  Future<void> atualizarStatus({
    required String pagamentoId,
    required StatusPagamento status,
    DateTime? dataConfirmacao,
  });
}
