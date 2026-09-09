import 'package:tcc_frete_urbano/domain/entities/historico_status_service.dart';
import 'package:tcc_frete_urbano/domain/enums/status_servico.dart';

class ServicoEntity {
  final String id;
  final String solicitacaoId;
  final String orcamentoId;
  final String clienteId;
  final String prestadorId;
  final String veiculoId;
  final double valorTotal;
  final StatusServico status;
  final DateTime dataAgendada;
  final String horarioAgendado;
  final DateTime? iniciadoEm;
  final DateTime? concluidoEm;
  final List<HistoricoStatusServico> historico;

  const ServicoEntity({
    required this.id,
    required this.solicitacaoId,
    required this.orcamentoId,
    required this.clienteId,
    required this.prestadorId,
    required this.veiculoId,
    required this.valorTotal,
    required this.status,
    required this.dataAgendada,
    required this.horarioAgendado,
    this.iniciadoEm,
    this.concluidoEm,
    this.historico = const [],
  });

  // Métodos de regra de negócio comparando diretamente com o Enum
  bool podeIniciar() => status == StatusServico.agendado;

  bool podeConcluir() => status == StatusServico.emAndamento;

  bool podeAvaliar() => status == StatusServico.concluido;

  bool podeCancelar() =>
      status == StatusServico.agendado ||
      status == StatusServico.prestadorACaminho;
}
