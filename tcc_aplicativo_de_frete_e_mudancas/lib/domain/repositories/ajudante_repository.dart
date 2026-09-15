import '../entities/ajudante_entity.dart';

abstract class AjudanteRepository {
  Future<List<AjudanteEntity>> listarPorPrestadorId(String id);
  Future<void> salvar(AjudanteEntity ajudante);
  Future<void> excluir(String id);
}
