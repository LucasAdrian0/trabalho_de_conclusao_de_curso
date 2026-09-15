import '../../domain/entities/notificacoes_entity.dart';
import '../mappers/database_enums.dart';

class NotificacoesModel extends NotificacoesEntity {
  const NotificacoesModel({
    required super.id,
    required super.usuarioId,
    required super.tipo,
    super.titulo,
    required super.mensagem,
    super.lida,
    required super.criadoEm,
  });
  factory NotificacoesModel.fromJson(Map<String, dynamic> j) =>
      NotificacoesModel(
        id: j['id'],
        usuarioId: j['usuario_id'],
        tipo: TipoNotificacaoMapper.fromDatabase(j['tipo']),
        titulo: j['titulo'],
        mensagem: j['mensagem'],
        lida: j['lida'] ?? false,
        criadoEm: DateTime.parse(j['criado_em']),
      );
  NotificacoesEntity toEntity() => NotificacoesEntity(
    id: id,
    usuarioId: usuarioId,
    tipo: tipo,
    titulo: titulo,
    mensagem: mensagem,
    lida: lida,
    criadoEm: criadoEm,
  );
}
