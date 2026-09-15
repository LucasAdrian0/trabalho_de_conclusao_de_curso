import '../../domain/entities/ajudante_entity.dart';

class AjudanteModel extends AjudanteEntity {
  const AjudanteModel({
    required super.id,
    required super.prestadorId,
    required super.quantidadeDisponivel,
    required super.valorPorAjudante,
    super.disponivel,
  });
  factory AjudanteModel.fromJson(Map<String, dynamic> j) => AjudanteModel(
    id: j['id'],
    prestadorId: j['prestador_id'],
    quantidadeDisponivel: j['quantidade_disponivel'],
    valorPorAjudante: (j['valor_por_ajudante'] as num).toDouble(),
    disponivel: j['disponivel'] ?? true,
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'prestador_id': prestadorId,
    'quantidade_disponivel': quantidadeDisponivel,
    'valor_por_ajudante': valorPorAjudante,
    'disponivel': disponivel,
  };
  AjudanteEntity toEntity() => AjudanteEntity(
    id: id,
    prestadorId: prestadorId,
    quantidadeDisponivel: quantidadeDisponivel,
    valorPorAjudante: valorPorAjudante,
    disponivel: disponivel,
  );
  factory AjudanteModel.fromEntity(AjudanteEntity e) => AjudanteModel(
    id: e.id,
    prestadorId: e.prestadorId,
    quantidadeDisponivel: e.quantidadeDisponivel,
    valorPorAjudante: e.valorPorAjudante,
    disponivel: e.disponivel,
  );
}
