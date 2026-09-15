import '../../domain/entities/orcamento_entity.dart';
import '../../domain/enums/status_orcamento.dart';
import '../../domain/repositories/orcamento_repository.dart';
import '../datasources/orcamento_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../mappers/database_enums.dart';
import '../models/orcamento_model.dart';

class OrcamentoRepositoryImpl implements OrcamentoRepository {
  final OrcamentoRemoteDataSource dataSource;
  OrcamentoRepositoryImpl(this.dataSource);

  @override
  Future<OrcamentoEntity> criar(OrcamentoEntity orcamento) =>
      executarRepositorio(
        () async => (await dataSource.criar(
          OrcamentoModel.fromEntity(orcamento),
        )).toEntity(),
      );
  @override
  Future<List<OrcamentoEntity>> gerarAutomaticos(String solicitacaoId) =>
      executarRepositorio(
        () async => (await dataSource.gerarAutomaticos(
          solicitacaoId,
        )).map((model) => model.toEntity()).toList(),
      );
  @override
  Future<List<OrcamentoEntity>> listarPorSolicitacao(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarSolicitacao(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<List<OrcamentoEntity>> listarPorPrestador(String id) =>
      executarRepositorio(
        () async => (await dataSource.listarPrestador(
          id,
        )).map((m) => m.toEntity()).toList(),
      );
  @override
  Future<OrcamentoEntity> atualizarStatus(String id, StatusOrcamento status) =>
      executarRepositorio(
        () async => (await dataSource.atualizarStatus(
          id,
          status.databaseValue,
        )).toEntity(),
      );
}
