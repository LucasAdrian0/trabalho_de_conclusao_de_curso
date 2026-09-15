import '../../domain/entities/solicitacao_entity.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../datasources/solicitacao_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';
import '../models/solicitacao_model.dart';

class SolicitacaoRepositoryImpl implements SolicitacaoRepository {
  final SolicitacaoRemoteDataSource dataSource;
  SolicitacaoRepositoryImpl(this.dataSource);

  @override
  Future<SolicitacaoEntity?> buscarPorId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<List<SolicitacaoEntity>> listarPorClienteId(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarCliente(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<List<SolicitacaoEntity>> listarAbertas() => executarRepositorio(
    () async =>
        (await dataSource.listarAbertas()).map((m) => m.toEntity()).toList(),
  );
  @override
  Future<void> salvar(SolicitacaoEntity solicitacao) => executarRepositorio(
    () => dataSource.criar(SolicitacaoModel.fromEntity(solicitacao)),
  );
  @override
  Future<void> atualizarStatus(String id, StatusSolicitacao status) =>
      executarRepositorio(
        () => dataSource.atualizarStatus(id, status.databaseValue),
      );
}
