import '../entities/notificacoes_entity.dart';

abstract class NotificacoesRepository {
  Future<List<NotificacoesEntity>> listarPorUsuarioId(String usuarioId);
  Future<void> marcarComoLida(String notificacaoId);
  Future<void> criar(NotificacoesEntity notificacao);
}