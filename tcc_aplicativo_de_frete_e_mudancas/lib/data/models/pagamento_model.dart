import '../../domain/entities/pagamento_entity.dart';
import '../mappers/database_enums.dart';

class PagamentoModel extends PagamentoEntity {
  const PagamentoModel({
    required super.id,
    required super.servicoId,
    required super.metodo,
    required super.valor,
    required super.status,
    super.gateway,
    super.gatewayTransacaoId,
    required super.criadoEm,
    required super.atualizadoEm,
  });
  factory PagamentoModel.fromJson(Map<String, dynamic> j) => PagamentoModel(
    id: j['id'],
    servicoId: j['servico_id'],
    metodo: MetodoPagamentoMapper.fromDatabase(j['metodo']),
    valor: (j['valor'] as num).toDouble(),
    status: StatusPagamentoMapper.fromDatabase(j['status']),
    gateway: j['gateway'],
    gatewayTransacaoId: j['gateway_transacao_id'],
    criadoEm: DateTime.parse(j['criado_em']),
    atualizadoEm: DateTime.parse(j['atualizado_em']),
  );
  PagamentoEntity toEntity() => PagamentoEntity(
    id: id,
    servicoId: servicoId,
    metodo: metodo,
    valor: valor,
    status: status,
    gateway: gateway,
    gatewayTransacaoId: gatewayTransacaoId,
    criadoEm: criadoEm,
    atualizadoEm: atualizadoEm,
  );
}
