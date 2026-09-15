import '../entities/notificacoes_entity.dart';

abstract class NotificacoesRepository {
  Future<List<NotificacoesEntity>> listarPorUsuarioId(String id);
  Future<void> marcarComoLida(String id);
}
