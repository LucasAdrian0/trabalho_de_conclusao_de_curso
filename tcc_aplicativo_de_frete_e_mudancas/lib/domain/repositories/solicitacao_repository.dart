import '../entities/solicitacao_entity.dart';
import '../enums/status_solicitacao.dart';

abstract class SolicitacaoRepository {
  Future<SolicitacaoEntity?> buscarPorId(String id);
  Future<List<SolicitacaoEntity>> listarPorClienteId(String id);
  Future<List<SolicitacaoEntity>> listarAbertas();
  Future<void> salvar(SolicitacaoEntity solicitacao);
  Future<void> atualizarStatus(String id, StatusSolicitacao status);
}
