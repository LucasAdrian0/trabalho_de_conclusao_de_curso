import '../mappers/database_enums.dart';
import '../../domain/entities/veiculo.dart';
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
      tipo: TipoVeiculoMapper.fromDatabase(json['tipo'] as String),
      marca: json['marca'] as String? ?? '',
      modelo: json['modelo'] as String? ?? '',
      ano: json['ano'] as int? ?? 0,
      capacidadeKg: (json['capacidade_kg'] as num?)?.toDouble() ?? 0,
      dimensoes: DimensoesVeiculoModel.fromJson({
        'largura': json['largura_m'] ?? 0,
        'altura': json['altura_m'] ?? 0,
        'comprimento': json['comprimento_m'] ?? 0,
      }),
      valorKm: (json['valor_km'] as num).toDouble(),
      status: StatusVeiculoMapper.fromDatabase(json['status'] as String?),
      fotoUrl: json['foto_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prestador_id': prestadorId,
      'tipo': tipo.databaseValue,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'capacidade_kg': capacidadeKg,
      'largura_m': dimensoes.largura,
      'altura_m': dimensoes.altura,
      'comprimento_m': dimensoes.comprimento,
      'valor_km': valorKm,
      'status': status.databaseValue,
      'foto_url': fotoUrl,
    };
  }

  Veiculo toEntity() => Veiculo(
    id: id,
    prestadorId: prestadorId,
    tipo: tipo,
    marca: marca,
    modelo: modelo,
    ano: ano,
    capacidadeKg: capacidadeKg,
    dimensoes: DimensoesVeiculoModel.fromEntity(dimensoes).toEntity(),
    valorKm: valorKm,
    status: status,
    fotoUrl: fotoUrl,
  );

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
