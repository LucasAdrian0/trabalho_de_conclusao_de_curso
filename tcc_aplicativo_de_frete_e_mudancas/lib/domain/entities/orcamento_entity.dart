import '../errors/falha.dart';
import '../enums/status_orcamento.dart';

class OrcamentoEntity {
  final String id;
  final String solicitacaoId;
  final String prestadorId;
  final String veiculoId;
  final double valorKmAplicado;
  final double valorTransporte;
  final int quantidadeAjudantes;
  final double valorAjudantes;
  final double valorTotalEstimado;
  final double? distanciaPrestadorOrigemKm;
  final int? tempoEstimadoMin;
  final StatusOrcamento status;
  final DateTime? expiraEm;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;
  const OrcamentoEntity({
    required this.id,
    required this.solicitacaoId,
    required this.prestadorId,
    required this.veiculoId,
    required this.valorKmAplicado,
    required this.valorTransporte,
    required this.quantidadeAjudantes,
    required this.valorAjudantes,
    required this.valorTotalEstimado,
    this.distanciaPrestadorOrigemKm,
    this.tempoEstimadoMin,
    required this.status,
    this.expiraEm,
    required this.criadoEm,
    this.atualizadoEm,
  });

  void validarCriacao() {
    if (status != StatusOrcamento.pendente) {
      throw const Falha(
        TipoFalha.validacao,
        'O orçamento deve começar pendente.',
      );
    }
    for (final valor in [
      valorKmAplicado,
      valorTransporte,
      valorAjudantes,
      valorTotalEstimado,
    ]) {
      if (!valor.isFinite || valor < 0) {
        throw const Falha(
          TipoFalha.validacao,
          'Valores do orçamento inválidos.',
        );
      }
    }
    if (quantidadeAjudantes < 0 ||
        (tempoEstimadoMin != null && tempoEstimadoMin! < 0) ||
        (distanciaPrestadorOrigemKm != null &&
            (!distanciaPrestadorOrigemKm!.isFinite ||
                distanciaPrestadorOrigemKm! < 0))) {
      throw const Falha(
        TipoFalha.validacao,
        'Estimativas do orçamento inválidas.',
      );
    }
    if ((valorTotalEstimado * 100).round() !=
        (valorTransporte * 100).round() + (valorAjudantes * 100).round()) {
      throw const Falha(
        TipoFalha.validacao,
        'O total deve corresponder ao transporte mais ajudantes.',
      );
    }
  }
}
