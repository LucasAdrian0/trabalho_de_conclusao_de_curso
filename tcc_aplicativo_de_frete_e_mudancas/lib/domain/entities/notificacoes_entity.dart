import '../enums/tipo_notificacao.dart';

class NotificacoesEntity {
  final String id;
  final String usuarioId;
  final TipoNotificacao tipo;
  final String? titulo;
  final String mensagem;
  final bool lida;
  final DateTime criadoEm;

  const NotificacoesEntity({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    this.titulo,
    required this.mensagem,
    this.lida = false,
    required this.criadoEm,
  });
}
