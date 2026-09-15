import '../enums/status_solicitacao.dart';
import '../errors/falha.dart';
import 'historico_status_entity.dart';

class ServicoEntity {
  final String id;
  final String solicitacaoId;
  final String orcamentoId;
  final String prestadorId;
  final String veiculoId;
  final DateTime? dataInicio;
  final DateTime? dataConclusao;
  final StatusSolicitacao status;
  final DateTime criadoEm;
  final List<HistoricoStatusEntity> historico;
  const ServicoEntity({
    required this.id,
    required this.solicitacaoId,
    required this.orcamentoId,
    required this.prestadorId,
    required this.veiculoId,
    this.dataInicio,
    this.dataConclusao,
    required this.status,
    required this.criadoEm,
    this.historico = const [],
  });

  bool podeAvaliar() => status == StatusSolicitacao.concluido;
  void validarTransicao(
    StatusSolicitacao nova,
    String usuarioId,
    String clienteId,
  ) {
    if (usuarioId != clienteId && usuarioId != prestadorId) {
      throw const Falha(
        TipoFalha.acessoNegado,
        'Serviço não pertence à sua conta.',
      );
    }
    final peloPrestador =
        usuarioId == prestadorId &&
        ((status == StatusSolicitacao.agendado &&
                {
                  StatusSolicitacao.aCaminho,
                  StatusSolicitacao.emAndamento,
                  StatusSolicitacao.canceladoPrestador,
                }.contains(nova)) ||
            (status == StatusSolicitacao.aCaminho &&
                {
                  StatusSolicitacao.emAndamento,
                  StatusSolicitacao.canceladoPrestador,
                }.contains(nova)) ||
            (status == StatusSolicitacao.emAndamento &&
                nova == StatusSolicitacao.concluido));
    final peloCliente =
        usuarioId == clienteId &&
        {
          StatusSolicitacao.agendado,
          StatusSolicitacao.aCaminho,
        }.contains(status) &&
        nova == StatusSolicitacao.canceladoCliente;
    if (nova != status && !peloPrestador && !peloCliente) {
      throw const Falha(
        TipoFalha.conflito,
        'Transição de serviço não permitida.',
      );
    }
  }
}
