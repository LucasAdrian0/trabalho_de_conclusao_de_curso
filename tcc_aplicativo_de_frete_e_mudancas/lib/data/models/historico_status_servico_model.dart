import 'package:tcc_frete_urbano/domain/entities/historico_status_service.dart';

class HistoricoStatusServicoModel extends HistoricoStatusServico {
  const HistoricoStatusServicoModel({
    required super.id,
    required super.servicoId,
    required super.statusAnterior,
    required super.statusNovo,
    required super.alteradoPorUsuarioId,
    super.observacao,
    required super.createdAt,
  });

  factory HistoricoStatusServicoModel.fromJson(Map<String, dynamic> json) {
    return HistoricoStatusServicoModel(
      id: json['id'] as String,
      servicoId: json['servico_id'] as String,
      statusAnterior: json['status_anterior'] as String?,
      statusNovo: json['status_novo'] as String,
      alteradoPorUsuarioId: json['alterado_por'] as String?,
      observacao: json['observacao'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servico_id': servicoId,
      'status_anterior': statusAnterior,
      'status_novo': statusNovo,
      'alterado_por': alteradoPorUsuarioId,
      if (observacao != null) 'observacao': observacao,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory HistoricoStatusServicoModel.fromEntity(
    HistoricoStatusServico entity,
  ) {
    return HistoricoStatusServicoModel(
      id: entity.id,
      servicoId: entity.servicoId,
      statusAnterior: entity.statusAnterior,
      statusNovo: entity.statusNovo,
      alteradoPorUsuarioId: entity.alteradoPorUsuarioId,
      observacao: entity.observacao,
      createdAt: entity.createdAt,
    );
  }
  HistoricoStatusServico toEntity() => HistoricoStatusServico(
    id: id,
    servicoId: servicoId,
    statusAnterior: statusAnterior,
    statusNovo: statusNovo,
    alteradoPorUsuarioId: alteradoPorUsuarioId,
    observacao: observacao,
    createdAt: createdAt,
  );
}
