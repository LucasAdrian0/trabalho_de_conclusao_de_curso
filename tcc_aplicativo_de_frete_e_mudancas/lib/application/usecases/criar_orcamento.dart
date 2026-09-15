import '../../domain/entities/orcamento_entity.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/orcamento_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../../domain/repositories/veiculo_repository.dart';
import '../../domain/repositories/ajudante_repository.dart';
import '../support/sessao.dart';

class CriarOrcamento {
  final AuthRepository _auth;
  final OrcamentoRepository _orcamentos;
  final SolicitacaoRepository _solicitacoes;
  final VeiculoRepository _veiculos;
  final AjudanteRepository _ajudantes;
  const CriarOrcamento(
    this._auth,
    this._orcamentos,
    this._solicitacoes,
    this._veiculos,
    this._ajudantes,
  );
  Future<OrcamentoEntity> call(OrcamentoEntity orcamento) async {
    final id = exigirUsuario(_auth);
    exigirProprietario(id, orcamento.prestadorId);
    orcamento.validarCriacao();
    final solicitacao = await _solicitacoes.buscarPorId(
      orcamento.solicitacaoId,
    );
    if (solicitacao == null || !solicitacao.podeReceberOrcamento()) {
      throw const Falha(
        TipoFalha.conflito,
        'A solicitação não está recebendo orçamentos.',
      );
    }
    final veiculo = await _veiculos.buscarPorId(orcamento.veiculoId);
    if (veiculo == null ||
        veiculo.prestadorId != id ||
        !veiculo.estaAptoParaUso()) {
      throw const Falha(
        TipoFalha.validacao,
        'Escolha um veículo ativo da sua conta.',
      );
    }
    if (orcamento.quantidadeAjudantesCotada > 0) {
      final ofertas = await _ajudantes.listarPorPrestadorId(id);
      final oferta = ofertas
          .where((item) => item.id == orcamento.ajudantesId)
          .firstOrNull;
      if (oferta == null ||
          !oferta.podeAtender(orcamento.quantidadeAjudantesCotada)) {
        throw const Falha(
          TipoFalha.validacao,
          'A oferta de ajudantes não atende à quantidade informada.',
        );
      }
    }
    return _orcamentos.criar(orcamento);
  }
}
