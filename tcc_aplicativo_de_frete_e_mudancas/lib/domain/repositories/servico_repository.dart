import '../entities/servico_entity.dart';
import '../enums/status_solicitacao.dart';

abstract class ServicoRepository {
  Future<ServicoEntity?> buscarPorId(String id);
  Future<List<ServicoEntity>> listarPorClienteId(String id);
  Future<List<ServicoEntity>> listarPorPrestadorId(String id);
  Future<ServicoEntity> aceitarOrcamento(String id);
  Future<void> atualizarStatus(String id, StatusSolicitacao status);
}
