import '../../domain/entities/veiculo.dart';
import '../../domain/enums/status_veiculo.dart';
import 'dimensoes_veiculo_model.dart';

class VeiculoModel extends Veiculo {
  const VeiculoModel({
    required super.id,
    required super.prestadorId,
    required super.tipo,
    required super.marca,
    required super.modelo,
    required super.ano,
    required super.capacidadeKg,
    required super.dimensoes,
    required super.valorKm,
    required super.status,
    super.fotoUrl,
  });

  factory VeiculoModel.fromJson(Map<String, dynamic> json) {
    return VeiculoModel(
      id: json['id'] as String,
      prestadorId: json['prestador_id'] as String,
      tipo: json['tipo'] as String,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      ano: json['ano'] as int,
      capacidadeKg: (json['capacidade_kg'] as num).toDouble(),
      dimensoes: DimensoesVeiculoModel.fromJson(
        json['dimensoes'] as Map<String, dynamic>,
      ),
      valorKm: (json['valor_km'] as num).toDouble(),
      status: StatusVeiculo.fromString(json['status'] as String?),
      fotoUrl: json['foto_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prestador_id': prestadorId,
      'tipo': tipo,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'capacidade_kg': capacidadeKg,
      'dimensoes': DimensoesVeiculoModel.fromEntity(dimensoes).toJson(),
      'valor_km': valorKm,
      'status': status.name,
      'foto_url': fotoUrl,
    };
  }

  Veiculo toEntity() => this;

  factory VeiculoModel.fromEntity(Veiculo entity) {
    return VeiculoModel(
      id: entity.id,
      prestadorId: entity.prestadorId,
      tipo: entity.tipo,
      marca: entity.marca,
      modelo: entity.modelo,
      ano: entity.ano,
      capacidadeKg: entity.capacidadeKg,
      dimensoes: entity.dimensoes,
      valorKm: entity.valorKm,
      status: entity.status,
      fotoUrl: entity.fotoUrl,
    );
  }
}