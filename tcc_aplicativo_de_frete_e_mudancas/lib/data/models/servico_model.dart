import 'package:tcc_frete_urbano/domain/enums/status_servico.dart';
import '../../domain/entities/servico_entity.dart';
import 'historico_status_servico_model.dart';

class ServicoModel extends ServicoEntity {
  const ServicoModel({
    required super.id,
    required super.solicitacaoId,
    required super.orcamentoId,
    required super.clienteId,
    required super.prestadorId,
    required super.veiculoId,
    required super.valorTotal,
    required super.status,
    required super.dataAgendada,
    required super.horarioAgendado,
    super.iniciadoEm,
    super.concluidoEm,
    super.historico,
  });

  factory ServicoModel.fromJson(Map<String, dynamic> json) {
    return ServicoModel(
      id: json['id'] as String,
      solicitacaoId: json['solicitacao_id'] as String,
      orcamentoId: json['orcamento_id'] as String,
      clienteId: json['cliente_id'] as String,
      prestadorId: json['prestador_id'] as String,
      veiculoId: json['veiculo_id'] as String,
      valorTotal: (json['valor_total'] as num).toDouble(),
      
      // Converte a String (snake_case ou camelCase) vinda do Supabase em StatusServico
      status: StatusServico.fromString(json['status'] as String?),
      
      dataAgendada: DateTime.parse(json['data_agendada'] as String),
      horarioAgendado: json['horario_agendado'] as String,
      iniciadoEm: json['iniciado_em'] != null
          ? DateTime.parse(json['iniciado_em'] as String)
          : null,
      concluidoEm: json['concluido_em'] != null
          ? DateTime.parse(json['concluido_em'] as String)
          : null,
      historico: json['historico'] != null
          ? (json['historico'] as List)
              .map((e) => HistoricoStatusServicoModel.fromJson(
                  e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solicitacao_id': solicitacaoId,
      'orcamento_id': orcamentoId,
      'cliente_id': clienteId,
      'prestador_id': prestadorId,
      'veiculo_id': veiculoId,
      'valor_total': valorTotal,
      
      // Converte a instância do enum para String na persitência
      'status': status.name,
      
      'data_agendada': dataAgendada.toIso8601String(),
      'horario_agendado': horarioAgendado,
      if (iniciadoEm != null) 'iniciado_em': iniciadoEm!.toIso8601String(),
      if (concluidoEm != null) 'concluido_em': concluidoEm!.toIso8601String(),
    };
  }

  ServicoEntity toEntity() => this;

  factory ServicoModel.fromEntity(ServicoEntity entity) {
    return ServicoModel(
      id: entity.id,
      solicitacaoId: entity.solicitacaoId,
      orcamentoId: entity.orcamentoId,
      clienteId: entity.clienteId,
      prestadorId: entity.prestadorId,
      veiculoId: entity.veiculoId,
      valorTotal: entity.valorTotal,
      status: entity.status,
      dataAgendada: entity.dataAgendada,
      horarioAgendado: entity.horarioAgendado,
      iniciadoEm: entity.iniciadoEm,
      concluidoEm: entity.concluidoEm,
      historico: entity.historico,
    );
  }
}