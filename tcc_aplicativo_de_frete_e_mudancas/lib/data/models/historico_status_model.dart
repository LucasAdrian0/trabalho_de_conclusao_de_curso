import '../../domain/entities/historico_status_entity.dart';

class HistoricoStatusModel extends HistoricoStatusEntity {
  const HistoricoStatusModel({
    required super.id,
    super.solicitacaoId,
    super.servicoId,
    super.statusAnterior,
    required super.statusNovo,
    super.alteradoPor,
    required super.alteradoEm,
  });
  factory HistoricoStatusModel.fromJson(Map<String, dynamic> j) =>
      HistoricoStatusModel(
        id: j['id'],
        solicitacaoId: j['solicitacao_id'],
        servicoId: j['servico_id'],
        statusAnterior: j['status_anterior'],
        statusNovo: j['status_novo'],
        alteradoPor: j['alterado_por'],
        alteradoEm: DateTime.parse(j['alterado_em']),
      );
  HistoricoStatusEntity toEntity() => HistoricoStatusEntity(
    id: id,
    solicitacaoId: solicitacaoId,
    servicoId: servicoId,
    statusAnterior: statusAnterior,
    statusNovo: statusNovo,
    alteradoPor: alteradoPor,
    alteradoEm: alteradoEm,
  );
}
