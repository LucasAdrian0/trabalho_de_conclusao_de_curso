import '../errors/executar_repositorio.dart';
import 'package:tcc_frete_urbano/data/datasources/notificacoes_remote_datasource.dart';
import '../../domain/entities/notificacoes_entity.dart';
import '../../domain/repositories/notificacoes_repository.dart';

class NotificacoesRepositoryImpl implements NotificacoesRepository {
  final NotificacoesRemoteDataSource remoteDataSource;

  NotificacoesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificacoesEntity>> listarPorUsuarioId(String usuarioId) =>
      executarRepositorio(() async {
        final models = await remoteDataSource.listarPorUsuarioId(usuarioId);
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<void> marcarComoLida(String notificacaoId) =>
      executarRepositorio(() async {
        await remoteDataSource.marcarComoLida(notificacaoId);
      });
}
