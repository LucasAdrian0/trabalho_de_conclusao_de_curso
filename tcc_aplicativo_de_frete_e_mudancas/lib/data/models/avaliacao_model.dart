import '../../domain/entities/avaliacao_entity.dart';

class AvaliacaoModel extends AvaliacaoEntity {
  const AvaliacaoModel({
    required super.id,
    required super.servicoId,
    required super.clienteId,
    required super.prestadorId,
    required super.nota,
    super.comentario,
    required super.createdAt,
  });

  factory AvaliacaoModel.fromJson(Map<String, dynamic> json) {
    return AvaliacaoModel(
      id: json['id'] as String,
      servicoId: json['servico_id'] as String,
      clienteId: json['cliente_id'] as String,
      prestadorId: json['prestador_id'] as String,
      nota: (json['nota'] as num).toDouble(),
      comentario: json['comentario'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'servico_id': servicoId,
      'cliente_id': clienteId,
      'prestador_id': prestadorId,
      'nota': nota.toInt(),
      if (comentario != null) 'comentario': comentario,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AvaliacaoEntity toEntity() => AvaliacaoEntity(
    id: id,
    servicoId: servicoId,
    clienteId: clienteId,
    prestadorId: prestadorId,
    nota: nota,
    comentario: comentario,
    createdAt: createdAt,
  );

  factory AvaliacaoModel.fromEntity(AvaliacaoEntity entity) {
    return AvaliacaoModel(
      id: entity.id,
      servicoId: entity.servicoId,
      clienteId: entity.clienteId,
      prestadorId: entity.prestadorId,
      nota: entity.nota,
      comentario: entity.comentario,
      createdAt: entity.createdAt,
    );
  }
}
