import '../mappers/database_enums.dart';

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
      clienteId:
          (json['servicos'] as Map<String, dynamic>)['cliente_id'] as String,
      valor: (json['valor'] as num).toDouble(),
      // Converte String do Supabase para Enum
      metodoPagamento: MetodoPagamentoMapper.fromDatabase(
        json['metodo'] as String,
      ),
      // Converte String do Supabase para Enum
      status: StatusPagamentoMapper.fromDatabase(json['status'] as String),
      transacaoId: json['gateway_transacao_id'] as String?,
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
      'valor': valor,
      // Converte o Enum para String utilizando .name
      'metodo': metodoPagamento.databaseValue,
      // Converte o Enum para String utilizando .name
      'status': status.databaseValue,
      if (transacaoId != null) 'gateway_transacao_id': transacaoId,
      if (aprovadoEm != null) 'aprovado_em': aprovadoEm!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  PagamentoEntity toEntity() => PagamentoEntity(
    id: id,
    servicoId: servicoId,
    clienteId: clienteId,
    valor: valor,
    metodoPagamento: metodoPagamento,
    status: status,
    transacaoId: transacaoId,
    aprovadoEm: aprovadoEm,
    createdAt: createdAt,
  );

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
