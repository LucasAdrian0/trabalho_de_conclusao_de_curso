import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';
import '../../domain/entities/orcamento_entity.dart';

class OrcamentoModel extends OrcamentoEntity {
  const OrcamentoModel({
    required super.id,
    required super.freteId,
    required super.prestadorId,
    required super.valor,
    super.observacao,
    required super.status,
    required super.criadoEm,
    super.atualizadoEm,
  });

  factory OrcamentoModel.fromJson(Map<String, dynamic> json) {
    return OrcamentoModel(
      id: json['id'] as String,
      freteId: json['frete_id'] as String,
      prestadorId: json['prestador_id'] as String,
      valor: (json['valor'] as num).toDouble(),
      observacao: json['observacao'] as String?,
      status: StatusOrcamento.values.byName(json['status'] as String),
      criadoEm: DateTime.parse(json['criado_em'] as String),
      atualizadoEm: json['atualizado_em'] != null
          ? DateTime.parse(json['atualizado_em'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'frete_id': freteId,
      'prestador_id': prestadorId,
      'valor': valor,
      'observacao': observacao,
      'status': status.name,
      'criado_em': criadoEm.toIso8601String(),
      'atualizado_em': atualizadoEm?.toIso8601String(),
    };
  }

  factory OrcamentoModel.fromEntity(OrcamentoEntity entity) {
    return OrcamentoModel(
      id: entity.id,
      freteId: entity.freteId,
      prestadorId: entity.prestadorId,
      valor: entity.valor,
      observacao: entity.observacao,
      status: entity.status,
      criadoEm: entity.criadoEm,
      atualizadoEm: entity.atualizadoEm,
    );
  }
}
