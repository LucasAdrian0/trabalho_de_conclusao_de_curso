import 'package:tcc_frete_urbano/data/datasources/orcamento_remote_datasouce.dart';
import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';
import 'package:tcc_frete_urbano/domain/repositories/orcamento_repository.dart';
import '../../domain/entities/orcamento_entity.dart';
import '../models/orcamento_model.dart';

class OrcamentoRepositoryImpl implements OrcamentoRepository {
  final OrcamentoRemoteDataSource _remoteDataSource;

  OrcamentoRepositoryImpl(this._remoteDataSource);

  @override
  Future<OrcamentoEntity> criarOrcamento(OrcamentoEntity orcamento) async {
    final model = OrcamentoModel.fromEntity(orcamento);
    return await _remoteDataSource.criar(model);
  }

  @override
  Future<List<OrcamentoEntity>> buscarPorFrete(String freteId) async {
    return await _remoteDataSource.buscarPorFrete(freteId);
  }

  @override
  Future<List<OrcamentoEntity>> buscarPorPrestador(String prestadorId) async {
    return await _remoteDataSource.buscarPorPrestador(prestadorId);
  }

  @override
  Future<OrcamentoEntity> atualizarStatus({
    required String orcamentoId,
    required StatusOrcamento novoStatus,
  }) async {
    return await _remoteDataSource.atualizarStatus(
      orcamentoId,
      novoStatus.name,
    );
  }
}