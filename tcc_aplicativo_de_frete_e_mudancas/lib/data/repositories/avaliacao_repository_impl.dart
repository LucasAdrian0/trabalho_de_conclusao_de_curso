import '../../domain/entities/avaliacao_entity.dart';
import '../../domain/repositories/avaliacao_repository.dart';
import '../datasources/avaliacao_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../models/avaliacao_model.dart';

class AvaliacaoRepositoryImpl implements AvaliacaoRepository {
  final AvaliacaoRemoteDataSource dataSource;
  AvaliacaoRepositoryImpl(this.dataSource);

  @override
  Future<void> salvar(AvaliacaoEntity avaliacao) => executarRepositorio(
    () => dataSource.salvar(AvaliacaoModel.fromEntity(avaliacao)),
  );
  @override
  Future<List<AvaliacaoEntity>> listarPorPrestadorId(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarPrestador(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<AvaliacaoEntity?> buscarPorServicoId(String id) => executarRepositorio(
    () async => (await dataSource.buscarServico(id))?.toEntity(),
  );
}
