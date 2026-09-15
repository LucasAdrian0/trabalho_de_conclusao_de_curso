import '../entities/veiculo.dart';
import '../enums/status_veiculo.dart';

abstract class VeiculoRepository {
  Future<Veiculo?> buscarPorId(String id);
  Future<List<Veiculo>> listarPorPrestadorId(String id);
  Future<void> salvar(Veiculo veiculo);
  Future<void> atualizarStatus(String id, StatusVeiculo status);
  Future<void> excluir(String id);
}
