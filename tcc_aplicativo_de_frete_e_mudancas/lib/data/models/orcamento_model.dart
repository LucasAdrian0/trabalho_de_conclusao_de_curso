import '../../domain/entities/orcamento_entity.dart';
import '../../domain/enums/status_orcamento.dart';

class OrcamentoModel extends OrcamentoEntity {
  const OrcamentoModel({
    required super.id,
    required super.solicitacaoId,
    required super.prestadorId,
    required super.veiculoId,
    required super.valorKmAplicado,
    required super.valorTransporte,
    required super.quantidadeAjudantes,
    required super.valorAjudantes,
    required super.valorTotalEstimado,
    super.distanciaPrestadorOrigemKm,
    super.tempoEstimadoMin,
    required super.status,
    super.expiraEm,
    required super.criadoEm,
    super.atualizadoEm,
  });
  factory OrcamentoModel.fromJson(Map<String, dynamic> json) => OrcamentoModel(
    id: json['id'] as String,
    solicitacaoId: json['solicitacao_id'] as String,
    prestadorId: json['prestador_id'] as String,
    veiculoId: json['veiculo_id'] as String,
    valorKmAplicado: (json['valor_km_aplicado'] as num).toDouble(),
    valorTransporte: (json['valor_transporte'] as num).toDouble(),
    quantidadeAjudantes: json['quantidade_ajudantes'] as int,
    valorAjudantes: (json['valor_ajudantes'] as num).toDouble(),
    valorTotalEstimado: (json['valor_total_estimado'] as num).toDouble(),
    distanciaPrestadorOrigemKm: (json['distancia_prestador_origem_km'] as num?)
        ?.toDouble(),
    tempoEstimadoMin: json['tempo_estimado_min'] as int?,
    status: StatusOrcamento.values.byName(json['status'] as String),
    expiraEm: json['expira_em'] == null
        ? null
        : DateTime.parse(json['expira_em'] as String),
    criadoEm: DateTime.parse(json['created_at'] as String),
    atualizadoEm: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'solicitacao_id': solicitacaoId,
    'prestador_id': prestadorId,
    'veiculo_id': veiculoId,
    'valor_km_aplicado': valorKmAplicado,
    'valor_transporte': valorTransporte,
    'quantidade_ajudantes': quantidadeAjudantes,
    'valor_ajudantes': valorAjudantes,
    'valor_total_estimado': valorTotalEstimado,
    'distancia_prestador_origem_km': distanciaPrestadorOrigemKm,
    'tempo_estimado_min': tempoEstimadoMin,
    'status': status.name,
    'expira_em': expiraEm?.toIso8601String(),
    'created_at': criadoEm.toIso8601String(),
    if (atualizadoEm != null) 'updated_at': atualizadoEm!.toIso8601String(),
  };
  factory OrcamentoModel.fromEntity(OrcamentoEntity e) => OrcamentoModel(
    id: e.id,
    solicitacaoId: e.solicitacaoId,
    prestadorId: e.prestadorId,
    veiculoId: e.veiculoId,
    valorKmAplicado: e.valorKmAplicado,
    valorTransporte: e.valorTransporte,
    quantidadeAjudantes: e.quantidadeAjudantes,
    valorAjudantes: e.valorAjudantes,
    valorTotalEstimado: e.valorTotalEstimado,
    distanciaPrestadorOrigemKm: e.distanciaPrestadorOrigemKm,
    tempoEstimadoMin: e.tempoEstimadoMin,
    status: e.status,
    expiraEm: e.expiraEm,
    criadoEm: e.criadoEm,
    atualizadoEm: e.atualizadoEm,
  );
  OrcamentoEntity toEntity() => OrcamentoEntity(
    id: id,
    solicitacaoId: solicitacaoId,
    prestadorId: prestadorId,
    veiculoId: veiculoId,
    valorKmAplicado: valorKmAplicado,
    valorTransporte: valorTransporte,
    quantidadeAjudantes: quantidadeAjudantes,
    valorAjudantes: valorAjudantes,
    valorTotalEstimado: valorTotalEstimado,
    distanciaPrestadorOrigemKm: distanciaPrestadorOrigemKm,
    tempoEstimadoMin: tempoEstimadoMin,
    status: status,
    expiraEm: expiraEm,
    criadoEm: criadoEm,
    atualizadoEm: atualizadoEm,
  );
}
