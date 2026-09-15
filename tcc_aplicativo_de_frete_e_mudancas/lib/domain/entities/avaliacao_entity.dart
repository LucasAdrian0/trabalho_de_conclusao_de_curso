import '../errors/falha.dart';

class AvaliacaoEntity {
  final String id;
  final String servicoId;
  final String clienteId;
  final String prestadorId;
  final int nota;
  final String? comentario;
  final DateTime criadoEm;

  const AvaliacaoEntity({
    required this.id,
    required this.servicoId,
    required this.clienteId,
    required this.prestadorId,
    required this.nota,
    this.comentario,
    required this.criadoEm,
  });
  void validar() {
    if (nota < 1 || nota > 5) {
      throw const Falha(TipoFalha.validacao, 'A nota deve estar entre 1 e 5.');
    }
  }
}
