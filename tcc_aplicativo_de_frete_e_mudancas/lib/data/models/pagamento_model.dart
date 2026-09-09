import 'package:tcc_frete_urbano/domain/enums/metodo_pagamento.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';

import '../../domain/entities/pagamento_entity.dart';


class PagamentoModel extends PagamentoEntity {
  const PagamentoModel({
    required super.id,
    required super.servicoId,
    required super.clienteId,
    required super.valor,
    required super.metodoPagamento,
    required super.status,
    super.transacaoId,
    super.aprovadoEm,
    required super.createdAt,
  });

  factory PagamentoModel.fromJson(Map<String, dynamic> json) {
    return PagamentoModel(
      id: json['id'] as String,
      servicoId: json['servico_id'] as String,
      clienteId: json['cliente_id'] as String,
      valor: (json['valor'] as num).toDouble(),
      // Converte String do Supabase para Enum
      metodoPagamento: MetodoPagamento.values.byName(
        json['metodo_pagamento'] as String,
      ),
      // Converte String do Supabase para Enum
      status: StatusPagamento.values.byName(
        json['status'] as String,
      ),
      transacaoId: json['transacao_id'] as String?,
      aprovadoEm: json['aprovado_em'] != null
          ? DateTime.parse(json['aprovado_em'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servico_id': servicoId,
      'cliente_id': clienteId,
      'valor': valor,
      // Converte o Enum para String utilizando .name
      'metodo_pagamento': metodoPagamento.name,
      // Converte o Enum para String utilizando .name
      'status': status.name,
      if (transacaoId != null) 'transacao_id': transacaoId,
      if (aprovadoEm != null) 'aprovado_em': aprovadoEm!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  PagamentoEntity toEntity() => this;

  factory PagamentoModel.fromEntity(PagamentoEntity entity) {
    return PagamentoModel(
      id: entity.id,
      servicoId: entity.servicoId,
      clienteId: entity.clienteId,
      valor: entity.valor,
      metodoPagamento: entity.metodoPagamento,
      status: entity.status,
      transacaoId: entity.transacaoId,
      aprovadoEm: entity.aprovadoEm,
      createdAt: entity.createdAt,
    );
  }
}