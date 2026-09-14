import '../entities/pagamento_entity.dart';

/// Consulta de pagamentos. Confirmação/estorno pertencem ao backend.
abstract class PagamentoRepository {
  Future<PagamentoEntity?> buscarPorServicoId(String servicoId);
}
