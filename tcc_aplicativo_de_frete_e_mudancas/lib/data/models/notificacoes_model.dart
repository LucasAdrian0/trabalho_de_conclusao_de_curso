import '../../domain/entities/notificacoes_entity.dart';

class NotificacoesModel extends NotificacoesEntity {
  const NotificacoesModel({
    required super.id,
    required super.usuarioId,
    required super.titulo,
    required super.mensagem,
    required super.tipo,
    super.lida,
    super.lidaEm,
    required super.createdAt,
  });

  factory NotificacoesModel.fromJson(Map<String, dynamic> json) {
    return NotificacoesModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      titulo: json['titulo'] as String,
      mensagem: json['mensagem'] as String,
      tipo: json['tipo'] as String,
      lida: json['lida'] as bool? ?? false,
      lidaEm: json['lida_em'] != null
          ? DateTime.parse(json['lida_em'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'mensagem': mensagem,
      'tipo': tipo,
      'lida': lida,
      if (lidaEm != null) 'lida_em': lidaEm!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificacoesEntity toEntity() => this;

  factory NotificacoesModel.fromEntity(NotificacoesEntity entity) {
    return NotificacoesModel(
      id: entity.id,
      usuarioId: entity.usuarioId,
      titulo: entity.titulo,
      mensagem: entity.mensagem,
      tipo: entity.tipo,
      lida: entity.lida,
      lidaEm: entity.lidaEm,
      createdAt: entity.createdAt,
    );
  }
}