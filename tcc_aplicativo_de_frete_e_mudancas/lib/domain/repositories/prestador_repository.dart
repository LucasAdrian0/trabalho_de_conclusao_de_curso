import '../entities/prestador_entity.dart';
import '../enums/status_disponibilidade.dart';

abstract class PrestadorRepository {
  Future<PrestadorEntity?> buscarPorUsuarioId(String id);
  Future<List<PrestadorEntity>> listarDisponiveis(String regiao);
  Future<void> salvar(PrestadorEntity prestador);
  Future<void> alterarDisponibilidade(String id, StatusDisponibilidade status);
}
