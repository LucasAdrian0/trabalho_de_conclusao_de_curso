import '../errors/falha.dart';

class ItemMudancaEntity {
  final String id;
  final String solicitacaoId;
  final String descricao;
  final int quantidade;
  final double? volumeM3;

  const ItemMudancaEntity({
    required this.id,
    required this.solicitacaoId,
    required this.descricao,
    required this.quantidade,
    this.volumeM3,
  });
  void validar() {
    if (descricao.trim().isEmpty ||
        quantidade <= 0 ||
        (volumeM3 != null && (!volumeM3!.isFinite || volumeM3! < 0))) {
      throw const Falha(TipoFalha.validacao, 'Item da mudança inválido.');
    }
  }
}
