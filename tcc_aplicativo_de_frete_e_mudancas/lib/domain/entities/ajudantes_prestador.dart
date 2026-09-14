import '../errors/falha.dart';

class AjudantesPrestador {
  final String prestadorId;
  final bool ofereceAjudantes;
  final int quantidadeDisponivel;
  final double valorPorAjudante;

  const AjudantesPrestador({
    required this.prestadorId,
    required this.ofereceAjudantes,
    required this.quantidadeDisponivel,
    required this.valorPorAjudante,
  });

  bool podeAtenderQuantidade(int quantidadeSolicitada) {
    return quantidadeSolicitada > 0 &&
        ofereceAjudantes &&
        quantidadeSolicitada <= quantidadeDisponivel;
  }

  double calcularCustoAjudantes(int quantidade) {
    if (!podeAtenderQuantidade(quantidade)) {
      throw Falha(TipoFalha.validacao, 'Quantidade de ajudantes indisponível.');
    }
    return quantidade * valorPorAjudante;
  }

  void validar() {
    if (quantidadeDisponivel < 0 ||
        !valorPorAjudante.isFinite ||
        valorPorAjudante < 0) {
      throw Falha(
        TipoFalha.validacao,
        'Quantidade e valor de ajudantes inválidos.',
      );
    }
  }
}
