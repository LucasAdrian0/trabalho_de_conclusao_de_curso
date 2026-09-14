import '../../domain/entities/ajudantes_prestador.dart';

class AjudantesPrestadorModel extends AjudantesPrestador {
  const AjudantesPrestadorModel({
    required super.prestadorId,
    required super.ofereceAjudantes,
    required super.quantidadeDisponivel,
    required super.valorPorAjudante,
  });

  factory AjudantesPrestadorModel.fromJson(Map<String, dynamic> json) {
    return AjudantesPrestadorModel(
      prestadorId: json['prestador_id'] as String,
      ofereceAjudantes: json['oferece_ajudantes'] as bool? ?? false,
      quantidadeDisponivel: json['quantidade_disponivel'] as int? ?? 0,
      valorPorAjudante: (json['valor_por_ajudante'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prestador_id': prestadorId,
      'oferece_ajudantes': ofereceAjudantes,
      'quantidade_disponivel': quantidadeDisponivel,
      'valor_por_ajudante': valorPorAjudante,
    };
  }

  AjudantesPrestador toEntity() => AjudantesPrestador(
    prestadorId: prestadorId,
    ofereceAjudantes: ofereceAjudantes,
    quantidadeDisponivel: quantidadeDisponivel,
    valorPorAjudante: valorPorAjudante,
  );

  factory AjudantesPrestadorModel.fromEntity(AjudantesPrestador entity) {
    return AjudantesPrestadorModel(
      prestadorId: entity.prestadorId,
      ofereceAjudantes: entity.ofereceAjudantes,
      quantidadeDisponivel: entity.quantidadeDisponivel,
      valorPorAjudante: entity.valorPorAjudante,
    );
  }
}
