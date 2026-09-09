class AvaliacaoEntity {
  final String id;
  final String servicoId;
  final String clienteId;
  final String prestadorId;
  final double nota; // Ex: 1.0 a 5.0
  final String? comentario;
  final DateTime createdAt;

  const AvaliacaoEntity({
    required this.id,
    required this.servicoId,
    required this.clienteId,
    required this.prestadorId,
    required this.nota,
    this.comentario,
    required this.createdAt,
  });

  bool eNotaMaxima() => nota >= 5.0;

  bool eNotaBaixa() => nota <= 1.0;
}