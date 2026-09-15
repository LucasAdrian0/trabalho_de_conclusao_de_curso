import '../enums/status_veiculo.dart';
import '../enums/tipo_veiculo.dart';
import '../errors/falha.dart';

class Veiculo {
  final String id;
  final String prestadorId;
  final TipoVeiculo tipo;
  final String? marca;
  final String? modelo;
  final int? ano;
  final double? capacidadeCargaKg;
  final double? comprimentoM;
  final double? larguraM;
  final double? alturaM;
  final double valorPorKm;
  final StatusVeiculo status;
  final String? regiaoAtendimento;
  final DateTime criadoEm;

  const Veiculo({
    required this.id,
    required this.prestadorId,
    required this.tipo,
    this.marca,
    this.modelo,
    this.ano,
    this.capacidadeCargaKg,
    this.comprimentoM,
    this.larguraM,
    this.alturaM,
    required this.valorPorKm,
    required this.status,
    this.regiaoAtendimento,
    required this.criadoEm,
  });
  bool estaAptoParaUso() => status == StatusVeiculo.ativo;
  double? get volumeM3 =>
      comprimentoM == null || larguraM == null || alturaM == null
      ? null
      : comprimentoM! * larguraM! * alturaM!;
  void validar() {
    if ([
      valorPorKm,
      capacidadeCargaKg,
      comprimentoM,
      larguraM,
      alturaM,
    ].whereType<double>().any((v) => !v.isFinite || v < 0)) {
      throw const Falha(
        TipoFalha.validacao,
        'Dados numéricos do veículo inválidos.',
      );
    }
  }
}
