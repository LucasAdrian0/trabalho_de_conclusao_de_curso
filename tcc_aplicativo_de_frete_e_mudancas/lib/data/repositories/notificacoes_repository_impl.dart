import '../../domain/entities/notificacoes_entity.dart';
import '../../domain/repositories/notificacoes_repository.dart';
import '../datasources/notificacao_remote_datasource.dart';
import '../errors/executar_repositorio.dart';

class NotificacoesRepositoryImpl implements NotificacoesRepository {
  final NotificacaoRemoteDataSource dataSource;
  NotificacoesRepositoryImpl(this.dataSource);

  @override
  Future<List<NotificacoesEntity>> listarPorUsuarioId(String id) =>
      executarRepositorio(
        () async =>
            (await dataSource.listar(id)).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<void> marcarComoLida(String id) =>
      executarRepositorio(() => dataSource.marcarLida(id));
}
