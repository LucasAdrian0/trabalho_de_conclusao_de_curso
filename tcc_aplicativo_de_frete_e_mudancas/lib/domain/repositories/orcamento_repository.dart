import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';

import '../entities/orcamento_entity.dart';

abstract class OrcamentoRepository {
  Future<OrcamentoEntity> criarOrcamento(OrcamentoEntity orcamento);
  Future<List<OrcamentoEntity>> buscarPorSolicitacao(String solicitacaoId);
  Future<List<OrcamentoEntity>> buscarPorPrestador(String prestadorId);
  Future<OrcamentoEntity> atualizarStatus({
    required String orcamentoId,
    required StatusOrcamento novoStatus,
  });
}
