import 'dimensoes_veiculo.dart';
import '../enums/status_veiculo.dart';

class Veiculo {
  final String id;
  final String prestadorId;
  final String tipo;
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
    return pesoKg <= capacidadeKg && volumeM3 <= dimensoes.volumeM3;
  }

  double calcularCustoBase(double distanciaKm) {
    return distanciaKm * valorKm;
  }
}