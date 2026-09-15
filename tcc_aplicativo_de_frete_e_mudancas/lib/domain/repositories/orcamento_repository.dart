import '../entities/orcamento_entity.dart';
import '../enums/status_orcamento.dart';

abstract class OrcamentoRepository {
  Future<OrcamentoEntity> criar(OrcamentoEntity orcamento);
  Future<List<OrcamentoEntity>> gerarAutomaticos(String solicitacaoId);
  Future<List<OrcamentoEntity>> listarPorSolicitacao(String id);
  Future<List<OrcamentoEntity>> listarPorPrestador(String id);
  Future<OrcamentoEntity> atualizarStatus(String id, StatusOrcamento status);
}
