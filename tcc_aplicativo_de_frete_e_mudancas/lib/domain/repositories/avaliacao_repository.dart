import '../entities/avaliacao_entity.dart';

abstract class AvaliacaoRepository {
  Future<void> salvar(AvaliacaoEntity avaliacao);
  Future<List<AvaliacaoEntity>> listarPorPrestadorId(String id);
  Future<AvaliacaoEntity?> buscarPorServicoId(String id);
}
