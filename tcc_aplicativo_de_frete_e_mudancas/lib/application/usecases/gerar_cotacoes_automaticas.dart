import '../../domain/entities/orcamento_entity.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/orcamento_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../support/sessao.dart';

class GerarCotacoesAutomaticas {
  final AuthRepository _auth;
  final SolicitacaoRepository _solicitacoes;
  final OrcamentoRepository _orcamentos;

  const GerarCotacoesAutomaticas(
    this._auth,
    this._solicitacoes,
    this._orcamentos,
  );

  Future<List<OrcamentoEntity>> call(String solicitacaoId) async {
    final usuarioId = exigirUsuario(_auth);
    final solicitacao = await _solicitacoes.buscarPorId(solicitacaoId);
    if (solicitacao == null) {
      throw const Falha(TipoFalha.naoEncontrado, 'Solicitação não encontrada.');
    }
    exigirProprietario(usuarioId, solicitacao.clienteId);
    if (solicitacao.status != StatusSolicitacao.aguardandoPrestador) {
      throw const Falha(
        TipoFalha.conflito,
        'A solicitação não está recebendo orçamentos.',
      );
    }
    if (solicitacao.distanciaKm == null || solicitacao.distanciaKm! <= 0) {
      throw const Falha(
        TipoFalha.validacao,
        'Calcule a distância da rota antes de gerar orçamentos.',
      );
    }
    return _orcamentos.gerarAutomaticos(solicitacaoId);
  }
}
