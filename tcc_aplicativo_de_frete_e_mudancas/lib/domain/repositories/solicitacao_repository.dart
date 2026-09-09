import '../entities/solicitacao_entity.dart';
import '../enums/status_solicitacao.dart';
import '../enums/tipo_servico_solicitado.dart';

abstract class SolicitacaoRepository {
  Future<SolicitacaoEntity?> buscarPorId(String id);
  
  Future<List<SolicitacaoEntity>> listarPorClienteId(String clienteId);
  
  /// Permite listar solicitações abertas filtrando por região e opcionalmente por tipo de serviço
  Future<List<SolicitacaoEntity>> listarAbertasPorRegiao(
    String cidade, 
    String estado, {
    TipoServicoSolicitado? tipoServico,
  });
  
  Future<void> salvar(SolicitacaoEntity solicitacao);
  
  /// Alterado de String para StatusSolicitacao para garantir type-safety
  Future<void> atualizarStatus(String solicitacaoId, StatusSolicitacao status);
}