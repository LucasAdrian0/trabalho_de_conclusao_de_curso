import '../entities/veiculo.dart';
import '../enums/status_veiculo.dart';

abstract class VeiculoRepository {
  Future<Veiculo?> buscarPorId(String id);
  Future<List<Veiculo>> listarPorPrestadorId(String prestadorId);
  Future<void> salvar(Veiculo veiculo);
  Future<void> atualizarStatus(String veiculoId, StatusVeiculo status);
  Future<void> deletar(String veiculoId);
}
