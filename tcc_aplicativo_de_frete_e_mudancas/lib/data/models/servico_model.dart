import '../../domain/entities/servico_entity.dart';
import '../mappers/database_enums.dart';
import 'historico_status_model.dart';

class ServicoModel extends ServicoEntity {
  const ServicoModel({
    required super.id,
    required super.solicitacaoId,
    required super.orcamentoId,
    required super.prestadorId,
    required super.veiculoId,
    super.dataInicio,
    super.dataConclusao,
    required super.status,
    required super.criadoEm,
    super.historico,
  });
  factory ServicoModel.fromJson(Map<String, dynamic> j) => ServicoModel(
    id: j['id'],
    solicitacaoId: j['solicitacao_id'],
    orcamentoId: j['orcamento_id'],
    prestadorId: j['prestador_id'],
    veiculoId: j['veiculo_id'],
    dataInicio: j['data_inicio'] == null
        ? null
        : DateTime.parse(j['data_inicio']),
    dataConclusao: j['data_conclusao'] == null
        ? null
        : DateTime.parse(j['data_conclusao']),
    status: StatusSolicitacaoMapper.fromDatabase(j['status']),
    criadoEm: DateTime.parse(j['criado_em']),
    historico: ((j['historico'] ?? []) as List)
        .map((e) => HistoricoStatusModel.fromJson(e).toEntity())
        .toList(),
  );
  ServicoEntity toEntity() => ServicoEntity(
    id: id,
    solicitacaoId: solicitacaoId,
    orcamentoId: orcamentoId,
    prestadorId: prestadorId,
    veiculoId: veiculoId,
    dataInicio: dataInicio,
    dataConclusao: dataConclusao,
    status: status,
    criadoEm: criadoEm,
    historico: historico,
  );
}
