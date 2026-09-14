import '../../domain/enums/status_solicitacao.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../support/sessao.dart';

class AtualizarStatusSolicitacao {
  final AuthRepository _auth;
  final SolicitacaoRepository _solicitacoes;
  const AtualizarStatusSolicitacao(this._auth, this._solicitacoes);
  Future<void> call(String solicitacaoId, StatusSolicitacao novoStatus) async {
    final id = exigirUsuario(_auth);
    final solicitacao = await _solicitacoes.buscarPorId(solicitacaoId);
    if (solicitacao == null) {
      throw const Falha(TipoFalha.naoEncontrado, 'Solicitação não encontrada.');
    }
    exigirProprietario(id, solicitacao.clienteId);
    solicitacao.validarTransicao(novoStatus);
    await _solicitacoes.atualizarStatus(solicitacaoId, novoStatus);
  }
}
