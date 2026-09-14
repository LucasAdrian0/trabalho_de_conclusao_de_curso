import '../../domain/entities/regiao_atendimento.dart';

class RegiaoAtendimentoModel extends RegiaoAtendimento {
  const RegiaoAtendimentoModel({
    required super.id,
    required super.prestadorId,
    required super.cidade,
    required super.estado,
    required super.raioKm,
  });

  factory RegiaoAtendimentoModel.fromJson(Map<String, dynamic> json) {
    return RegiaoAtendimentoModel(
      id: json['id'] as String,
      prestadorId: json['prestador_id'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      raioKm: (json['raio_km'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prestador_id': prestadorId,
      'cidade': cidade,
      'estado': estado,
      'raio_km': raioKm,
    };
  }

  RegiaoAtendimento toEntity() => RegiaoAtendimento(
    id: id,
    prestadorId: prestadorId,
    cidade: cidade,
    estado: estado,
    raioKm: raioKm,
  );

  factory RegiaoAtendimentoModel.fromEntity(RegiaoAtendimento entity) {
    return RegiaoAtendimentoModel(
      id: entity.id,
      prestadorId: entity.prestadorId,
      cidade: entity.cidade,
      estado: entity.estado,
      raioKm: entity.raioKm,
    );
  }
}
