class HistoricoStatusEntity {
  final String id;
  final String? solicitacaoId;
  final String? servicoId;
  final String? statusAnterior;
  final String statusNovo;
  final String? alteradoPor;
  final DateTime alteradoEm;
  const HistoricoStatusEntity({
    required this.id,
    this.solicitacaoId,
    this.servicoId,
    this.statusAnterior,
    required this.statusNovo,
    this.alteradoPor,
    required this.alteradoEm,
  });
}
