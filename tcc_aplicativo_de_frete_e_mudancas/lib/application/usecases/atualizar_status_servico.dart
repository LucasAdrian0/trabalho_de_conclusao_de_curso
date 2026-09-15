import '../../domain/enums/status_solicitacao.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/servico_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../support/sessao.dart';

class AtualizarStatusServico {
  final AuthRepository _auth;
  final ServicoRepository _servicos;
  final SolicitacaoRepository _solicitacoes;
  const AtualizarStatusServico(this._auth, this._servicos, this._solicitacoes);
  Future<void> call({
    required String servicoId,
    required StatusSolicitacao novoStatus,
  }) async {
    final id = exigirUsuario(_auth);
    final servico = await _servicos.buscarPorId(servicoId);
    if (servico == null) {
      throw const Falha(TipoFalha.naoEncontrado, 'Serviço não encontrado.');
    }
    final solicitacao = await _solicitacoes.buscarPorId(servico.solicitacaoId);
    if (solicitacao == null) {
      throw const Falha(TipoFalha.naoEncontrado, 'Solicitação não encontrada.');
    }
    servico.validarTransicao(novoStatus, id, solicitacao.clienteId);
    await _servicos.atualizarStatus(servicoId, novoStatus);
  }
}
