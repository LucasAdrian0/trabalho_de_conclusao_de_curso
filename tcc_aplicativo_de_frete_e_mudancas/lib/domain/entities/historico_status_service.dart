class HistoricoStatusServico {
  final String id;
  final String servicoId;
  final String? statusAnterior;
  final String statusNovo;
  final String? alteradoPorUsuarioId;
  final String? observacao;
  final DateTime createdAt;

  const HistoricoStatusServico({
    required this.id,
    required this.servicoId,
    required this.statusAnterior,
    required this.statusNovo,
    required this.alteradoPorUsuarioId,
    this.observacao,
    required this.createdAt,
  });
}
