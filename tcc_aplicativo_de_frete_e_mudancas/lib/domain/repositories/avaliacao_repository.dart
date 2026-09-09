import '../entities/avaliacao_entity.dart';

abstract class AvaliacaoRepository {
  Future<void> salvar(AvaliacaoEntity avaliacao);
  Future<List<AvaliacaoEntity>> listarPorPrestadorId(String prestadorId);
  Future<AvaliacaoEntity?> buscarPorServicoId(String servicoId);
}