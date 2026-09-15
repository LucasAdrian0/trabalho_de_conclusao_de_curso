import '../../domain/entities/orcamento_entity.dart';
import '../../domain/enums/status_orcamento.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/orcamento_repository.dart';
import '../support/sessao.dart';

/// Retirada de uma oferta pelo prestador; aceite é outro caso de uso.
class RecusarOrcamento {
  final AuthRepository _auth;
  final OrcamentoRepository _orcamentos;
  const RecusarOrcamento(this._auth, this._orcamentos);
  Future<OrcamentoEntity> call(String orcamentoId) async {
    exigirUsuario(_auth);
    return _orcamentos.atualizarStatus(orcamentoId, StatusOrcamento.recusado);
  }
}
