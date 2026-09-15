import '../errors/falha.dart';

class AjudanteEntity {
  final String id;
  final String prestadorId;
  final int quantidadeDisponivel;
  final double valorPorAjudante;
  final bool disponivel;

  const AjudanteEntity({
    required this.id,
    required this.prestadorId,
    required this.quantidadeDisponivel,
    required this.valorPorAjudante,
    this.disponivel = true,
  });

  void validar() {
    if (quantidadeDisponivel < 0 ||
        !valorPorAjudante.isFinite ||
        valorPorAjudante < 0) {
      throw const Falha(TipoFalha.validacao, 'Dados de ajudantes inválidos.');
    }
  }

  bool podeAtender(int quantidade) =>
      disponivel && quantidade > 0 && quantidade <= quantidadeDisponivel;
  double calcularCusto(int quantidade) {
    if (!podeAtender(quantidade)) {
      throw const Falha(
        TipoFalha.validacao,
        'Quantidade de ajudantes indisponível.',
      );
    }
    return quantidade * valorPorAjudante;
  }
}
