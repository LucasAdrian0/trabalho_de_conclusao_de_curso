import '../enums/metodo_pagamento.dart';
import '../enums/status_pagamento.dart';

class PagamentoEntity {
  final String id;
  final String servicoId;
  final MetodoPagamento metodo;
  final double valor;
  final StatusPagamento status;
  final String? gateway;
  final String? gatewayTransacaoId;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const PagamentoEntity({
    required this.id,
    required this.servicoId,
    required this.metodo,
    required this.valor,
    required this.status,
    this.gateway,
    this.gatewayTransacaoId,
    required this.criadoEm,
    required this.atualizadoEm,
  });
}
