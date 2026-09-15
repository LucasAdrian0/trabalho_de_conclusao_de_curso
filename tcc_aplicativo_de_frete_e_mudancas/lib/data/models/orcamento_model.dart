import '../../domain/entities/orcamento_entity.dart';
import '../mappers/database_enums.dart';

class OrcamentoModel extends OrcamentoEntity {
  const OrcamentoModel({
    required super.id,
    required super.solicitacaoId,
    required super.prestadorId,
    required super.veiculoId,
    super.ajudantesId,
    super.quantidadeAjudantesCotada,
    required super.valorTransporte,
    super.valorAjudantes,
    required super.valorTotal,
    super.tempoEstimadoMin,
    required super.status,
    required super.criadoEm,
  });
  factory OrcamentoModel.fromJson(Map<String, dynamic> j) => OrcamentoModel(
    id: j['id'],
    solicitacaoId: j['solicitacao_id'],
    prestadorId: j['prestador_id'],
    veiculoId: j['veiculo_id'],
    ajudantesId: j['ajudantes_id'],
    quantidadeAjudantesCotada: j['quantidade_ajudantes_cotada'] ?? 0,
    valorTransporte: (j['valor_transporte'] as num).toDouble(),
    valorAjudantes: (j['valor_ajudantes'] as num?)?.toDouble() ?? 0,
    valorTotal: (j['valor_total'] as num).toDouble(),
    tempoEstimadoMin: j['tempo_estimado_min'],
    status: StatusOrcamentoMapper.fromDatabase(j['status']),
    criadoEm: DateTime.parse(j['criado_em']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'solicitacao_id': solicitacaoId,
    'prestador_id': prestadorId,
    'veiculo_id': veiculoId,
    'ajudantes_id': ajudantesId,
    'quantidade_ajudantes_cotada': quantidadeAjudantesCotada,
    'valor_transporte': valorTransporte,
    'valor_ajudantes': valorAjudantes,
    'valor_total': valorTotal,
    'tempo_estimado_min': tempoEstimadoMin,
    'status': status.databaseValue,
    'criado_em': criadoEm.toIso8601String(),
  };
  OrcamentoEntity toEntity() => OrcamentoEntity(
    id: id,
    solicitacaoId: solicitacaoId,
    prestadorId: prestadorId,
    veiculoId: veiculoId,
    ajudantesId: ajudantesId,
    quantidadeAjudantesCotada: quantidadeAjudantesCotada,
    valorTransporte: valorTransporte,
    valorAjudantes: valorAjudantes,
    valorTotal: valorTotal,
    tempoEstimadoMin: tempoEstimadoMin,
    status: status,
    criadoEm: criadoEm,
  );
  factory OrcamentoModel.fromEntity(OrcamentoEntity e) => OrcamentoModel(
    id: e.id,
    solicitacaoId: e.solicitacaoId,
    prestadorId: e.prestadorId,
    veiculoId: e.veiculoId,
    ajudantesId: e.ajudantesId,
    quantidadeAjudantesCotada: e.quantidadeAjudantesCotada,
    valorTransporte: e.valorTransporte,
    valorAjudantes: e.valorAjudantes,
    valorTotal: e.valorTotal,
    tempoEstimadoMin: e.tempoEstimadoMin,
    status: e.status,
    criadoEm: e.criadoEm,
  );
}
