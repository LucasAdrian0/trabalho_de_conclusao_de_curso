import '../enums/tipo_notificacao.dart';

class NotificacoesEntity {
  final String id;
  final String usuarioId;
  final String titulo;
  final String mensagem;
  final TipoNotificacao
  tipo; // Ex: 'solicitacao', 'orcamento', 'servico', 'pagamento'
  final bool lida;
  final DateTime? lidaEm;
  final DateTime createdAt;

  const NotificacoesEntity({
    required this.id,
    required this.usuarioId,
    required this.titulo,
    required this.mensagem,
    required this.tipo,
    this.lida = false,
    this.lidaEm,
    required this.createdAt,
  });

  NotificacoesEntity marcarComoLida() {
    return NotificacoesEntity(
      id: id,
      usuarioId: usuarioId,
      titulo: titulo,
      mensagem: mensagem,
      tipo: tipo,
      lida: true,
      lidaEm: DateTime.now(),
      createdAt: createdAt,
    );
  }
}
