import '../entities/pagamento_entity.dart';

abstract class PagamentoRepository {
  Future<PagamentoEntity?> buscarPorServicoId(String id);
}
