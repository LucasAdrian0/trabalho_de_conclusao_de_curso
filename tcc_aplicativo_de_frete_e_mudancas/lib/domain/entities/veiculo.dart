import '../errors/falha.dart';
import '../enums/tipo_veiculo.dart';
import 'dimensoes_veiculo.dart';
import '../enums/status_veiculo.dart';

class Veiculo {
  final String id;
  final String prestadorId;
  final TipoVeiculo tipo;
  final String marca;
  final String modelo;
  final int ano;
  final double capacidadeKg;
  final DimensoesVeiculo dimensoes;
  final double valorKm;
  final StatusVeiculo status;
  final String? fotoUrl;

  const Veiculo({
    required this.id,
    required this.prestadorId,
    required this.tipo,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.capacidadeKg,
    required this.dimensoes,
    required this.valorKm,
    required this.status,
    this.fotoUrl,
  });

  // Comparação direta com o enum sem depender de Strings
  bool estaAptoParaUso() => status == StatusVeiculo.ativo;

  bool suportaCarga(double pesoKg, double volumeM3) {
    return pesoKg.isFinite &&
        volumeM3.isFinite &&
        pesoKg >= 0 &&
        volumeM3 >= 0 &&
        pesoKg <= capacidadeKg &&
        volumeM3 <= dimensoes.volumeM3;
  }

  double calcularCustoBase(double distanciaKm) {
    if (!distanciaKm.isFinite || distanciaKm < 0) {
      throw Falha(TipoFalha.validacao, 'Distância inválida.');
    }
    return distanciaKm * valorKm;
  }

  void validar() {
    if (!valorKm.isFinite ||
        valorKm < 0 ||
        !capacidadeKg.isFinite ||
        capacidadeKg < 0 ||
        !dimensoes.largura.isFinite ||
        dimensoes.largura < 0 ||
        !dimensoes.altura.isFinite ||
        dimensoes.altura < 0 ||
        !dimensoes.comprimento.isFinite ||
        dimensoes.comprimento < 0) {
      throw Falha(TipoFalha.validacao, 'Valores do veículo inválidos.');
    }
  }
}
