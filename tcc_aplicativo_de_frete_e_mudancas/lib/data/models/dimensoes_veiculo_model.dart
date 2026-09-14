import '../../domain/entities/dimensoes_veiculo.dart';

class DimensoesVeiculoModel extends DimensoesVeiculo {
  const DimensoesVeiculoModel({
    required super.largura,
    required super.altura,
    required super.comprimento,
  });

  factory DimensoesVeiculoModel.fromJson(Map<String, dynamic> json) {
    return DimensoesVeiculoModel(
      largura: (json['largura'] as num).toDouble(),
      altura: (json['altura'] as num).toDouble(),
      comprimento: (json['comprimento'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'largura': largura, 'altura': altura, 'comprimento': comprimento};
  }

  DimensoesVeiculo toEntity() => DimensoesVeiculo(
    largura: largura,
    altura: altura,
    comprimento: comprimento,
  );

  factory DimensoesVeiculoModel.fromEntity(DimensoesVeiculo entity) {
    return DimensoesVeiculoModel(
      largura: entity.largura,
      altura: entity.altura,
      comprimento: entity.comprimento,
    );
  }
}
