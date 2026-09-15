import '../enums/status_orcamento.dart';
import '../errors/falha.dart';

class OrcamentoEntity {
  final String id;
  final String solicitacaoId;
  final String prestadorId;
  final String veiculoId;
  final String? ajudantesId;
  final int quantidadeAjudantesCotada;
  final double valorTransporte;
  final double valorAjudantes;
  final double valorTotal;
  final int? tempoEstimadoMin;
  final StatusOrcamento status;
  final DateTime criadoEm;

  const OrcamentoEntity({
    required this.id,
    required this.solicitacaoId,
    required this.prestadorId,
    required this.veiculoId,
    this.ajudantesId,
    this.quantidadeAjudantesCotada = 0,
    required this.valorTransporte,
    this.valorAjudantes = 0,
    required this.valorTotal,
    this.tempoEstimadoMin,
    required this.status,
    required this.criadoEm,
  });
  void validarCriacao() {
    if (status != StatusOrcamento.pendente ||
        quantidadeAjudantesCotada < 0 ||
        [
          valorTransporte,
          valorAjudantes,
          valorTotal,
        ].any((v) => !v.isFinite || v < 0) ||
        (valorTotal * 100).round() !=
            (valorTransporte * 100).round() + (valorAjudantes * 100).round()) {
      throw const Falha(TipoFalha.validacao, 'Orçamento inválido.');
    }
    if (quantidadeAjudantesCotada > 0 && ajudantesId == null) {
      throw const Falha(
        TipoFalha.validacao,
        'Informe a oferta de ajudantes utilizada.',
      );
    }
  }
}
