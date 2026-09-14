import '../errors/falha.dart';

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
  void validar() {
    if (!nota.isFinite ||
        nota < 1 ||
        nota > 5 ||
        nota != nota.roundToDouble()) {
      throw Falha(
        TipoFalha.validacao,
        'A nota deve ser um inteiro entre 1 e 5.',
      );
    }
  }
}
