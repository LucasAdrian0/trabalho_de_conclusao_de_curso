class DimensoesVeiculo {
  final double largura;
  final double altura;
  final double comprimento;

  const DimensoesVeiculo({
    required this.largura,
    required this.altura,
    required this.comprimento,
  });

  double get volumeM3 => largura * altura * comprimento;
}