import '../../domain/entities/servico_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/servico_repository.dart';
import '../../domain/validation/credenciais.dart';
import '../support/sessao.dart';

class AceitarOrcamento {
  final AuthRepository _auth;
  final ServicoRepository _servicos;
  const AceitarOrcamento(this._auth, this._servicos);
  Future<ServicoEntity> call(String orcamentoId) async {
    exigirUsuario(_auth);
    final id = Credenciais.textoObrigatorio(orcamentoId, 'o orçamento');
    // O servidor verifica proprietário, estado e concorrência na mesma transação.
    return _servicos.aceitarOrcamento(id);
  }
}
