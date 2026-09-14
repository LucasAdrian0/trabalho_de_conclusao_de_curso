import '../errors/executar_repositorio.dart';
import 'package:tcc_frete_urbano/data/datasources/orcamento_remote_datasouce.dart';
import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';
import 'package:tcc_frete_urbano/domain/repositories/orcamento_repository.dart';
import '../../domain/entities/orcamento_entity.dart';
import '../models/orcamento_model.dart';

class OrcamentoRepositoryImpl implements OrcamentoRepository {
  final OrcamentoRemoteDataSource _remoteDataSource;

  OrcamentoRepositoryImpl(this._remoteDataSource);

  @override
  Future<OrcamentoEntity> criarOrcamento(OrcamentoEntity orcamento) =>
      executarRepositorio(() async {
        final model = OrcamentoModel.fromEntity(orcamento);
        return (await _remoteDataSource.criar(model)).toEntity();
      });

  @override
  Future<List<OrcamentoEntity>> buscarPorSolicitacao(String solicitacaoId) =>
      executarRepositorio(() async {
        return (await _remoteDataSource.buscarPorSolicitacao(
          solicitacaoId,
        )).map((model) => model.toEntity()).toList();
      });

  @override
  Future<List<OrcamentoEntity>> buscarPorPrestador(String prestadorId) =>
      executarRepositorio(() async {
        return (await _remoteDataSource.buscarPorPrestador(
          prestadorId,
        )).map((model) => model.toEntity()).toList();
      });

  @override
  Future<OrcamentoEntity> atualizarStatus({
    required String orcamentoId,
    required StatusOrcamento novoStatus,
  }) => executarRepositorio(() async {
    return (await _remoteDataSource.atualizarStatus(
      orcamentoId,
      novoStatus.name,
    )).toEntity();
  });
}
