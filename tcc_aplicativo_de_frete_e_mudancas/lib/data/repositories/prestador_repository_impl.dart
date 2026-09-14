import '../errors/executar_repositorio.dart';
import '../../domain/entities/prestador_entity.dart';
import '../../domain/enums/status_disponibilidade.dart';
import '../../domain/repositories/prestador_repository.dart';
import '../datasources/prestador_remote_datasource.dart';
import '../models/prestador_model.dart';

class PrestadorRepositoryImpl implements PrestadorRepository {
  final PrestadorRemoteDataSource remoteDataSource;

  PrestadorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PrestadorEntity?> buscarPorUsuarioId(String usuarioId) =>
      executarRepositorio(() async {
        final model = await remoteDataSource.buscarPorUsuarioId(usuarioId);
        return model?.toEntity();
      });

  @override
  Future<List<PrestadorEntity>> buscarDisponiveisPorRegiao(
    String cidade,
    String estado,
  ) => executarRepositorio(() async {
    final models = await remoteDataSource.buscarDisponiveisPorRegiao(
      cidade,
      estado,
    );
    return models.map((model) => model.toEntity()).toList();
  });

  @override
  Future<void> salvar(PrestadorEntity prestador) =>
      executarRepositorio(() async {
        final model = PrestadorModel.fromEntity(prestador);
        await remoteDataSource.salvar(model);
      });

  @override
  Future<void> atualizar(PrestadorEntity prestador) =>
      executarRepositorio(() async {
        final model = PrestadorModel.fromEntity(prestador);
        await remoteDataSource.atualizar(model);
      });

  @override
  Future<void> alterarDisponibilidade(
    String usuarioId,
    StatusDisponibilidade disponivel,
  ) => executarRepositorio(() async {
    await remoteDataSource.alterarDisponibilidade(usuarioId, disponivel);
  });
}
