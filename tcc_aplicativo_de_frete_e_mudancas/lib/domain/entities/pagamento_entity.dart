import 'package:tcc_frete_urbano/domain/enums/metodo_pagamento.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';

class PagamentoEntity {
  final String id;
  final String servicoId;
  final String clienteId;
  final double valor;
  final MetodoPagamento metodoPagamento; // Ex: 'pix', 'cartao_credito', 'boleto'
  final StatusPagamento status; // Ex: 'pendente', 'aprovado', 'recusado', 'reembolsado'
  final String? transacaoId;
  final DateTime? aprovadoEm;
  final DateTime createdAt;

  const PagamentoEntity({
    required this.id,
    required this.servicoId,
    required this.clienteId,
    required this.valor,
    required this.metodoPagamento,
    required this.status,
    this.transacaoId,
    this.aprovadoEm,
    required this.createdAt,
  });

bool estaPendente() => status == StatusPagamento.pendente;

bool estaAprovado() => status == StatusPagamento.aprovado;

bool estaRecusado() => status == StatusPagamento.recusado;

bool estaCancelado() => status == StatusPagamento.cancelado;

bool estaEstornado() => status == StatusPagamento.estornado;

bool foiFinalizado() => 
    status == StatusPagamento.aprovado || 
    status == StatusPagamento.recusado || 
    status == StatusPagamento.cancelado || 
    status == StatusPagamento.estornado;
}