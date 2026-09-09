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
    return ofereceAjudantes && quantidadeSolicitada <= quantidadeDisponivel;
  }

  double calcularCustoAjudantes(int quantidade) {
    if (!podeAtenderQuantidade(quantidade)) return 0.0;
    return quantidade * valorPorAjudante;
  }
}