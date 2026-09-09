import 'package:tcc_frete_urbano/data/models/notificacoes_remote_datasouce.dart';
import '../../domain/entities/notificacoes_entity.dart';
import '../../domain/repositories/notificacoes_repository.dart';
import '../models/notificacoes_model.dart';

class NotificacoesRepositoryImpl implements NotificacoesRepository {
  final NotificacoesRemoteDataSource remoteDataSource;

  NotificacoesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificacoesEntity>> listarPorUsuarioId(String usuarioId) async {
    final models = await remoteDataSource.listarPorUsuarioId(usuarioId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> marcarComoLida(String notificacaoId) async {
    await remoteDataSource.marcarComoLida(notificacaoId);
  }

  @override
  Future<void> criar(NotificacoesEntity notificacao) async {
    final model = NotificacoesModel.fromEntity(notificacao);
    await remoteDataSource.criar(model);
  }
}