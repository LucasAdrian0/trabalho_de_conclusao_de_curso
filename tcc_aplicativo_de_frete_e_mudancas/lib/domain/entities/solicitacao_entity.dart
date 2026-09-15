import '../enums/status_solicitacao.dart';
import '../enums/tipo_servico_solicitado.dart';
import '../errors/falha.dart';
import 'endereco_entity.dart';
import 'item_mudanca_entity.dart';

class SolicitacaoEntity {
  final String id;
  final String clienteId;
  final EnderecoEntity enderecoOrigem;
  final EnderecoEntity enderecoDestino;
  final DateTime dataDesejada;
  final TipoServicoSolicitado tipoServico;
  final double? volumeEstimadoM3;
  final bool necessitaAjudantes;
  final int quantidadeAjudantes;
  final double? distanciaKm;
  final Map<String, dynamic>? rotaGeoJson;
  final StatusSolicitacao status;
  final DateTime criadoEm;
  final DateTime atualizadoEm;
  final List<ItemMudancaEntity> itens;

  const SolicitacaoEntity({
    required this.id,
    required this.clienteId,
    required this.enderecoOrigem,
    required this.enderecoDestino,
    required this.dataDesejada,
    required this.tipoServico,
    this.volumeEstimadoM3,
    this.necessitaAjudantes = false,
    this.quantidadeAjudantes = 0,
    this.distanciaKm,
    this.rotaGeoJson,
    required this.status,
    required this.criadoEm,
    required this.atualizadoEm,
    this.itens = const [],
  });
  bool podeReceberOrcamento() =>
      status == StatusSolicitacao.aguardandoPrestador;
  bool podeSerCancelada() => {
    StatusSolicitacao.criada,
    StatusSolicitacao.aguardandoPrestador,
    StatusSolicitacao.pagamentoPendente,
    StatusSolicitacao.pagamentoRecusado,
  }.contains(status);
  void validar() {
    if (quantidadeAjudantes < 0 ||
        (volumeEstimadoM3 != null &&
            (!volumeEstimadoM3!.isFinite || volumeEstimadoM3! < 0)) ||
        (distanciaKm != null && (!distanciaKm!.isFinite || distanciaKm! < 0))) {
      throw const Falha(
        TipoFalha.validacao,
        'Valores da solicitação inválidos.',
      );
    }
    for (final item in itens) {
      item.validar();
      if (item.solicitacaoId != id) {
        throw const Falha(
          TipoFalha.validacao,
          'Item pertence a outra solicitação.',
        );
      }
    }
  }

  void validarTransicao(StatusSolicitacao nova) {
    if (nova == status ||
        (podeSerCancelada() && nova == StatusSolicitacao.canceladoCliente) ||
        (status == StatusSolicitacao.criada &&
            nova == StatusSolicitacao.aguardandoPrestador)) {
      return;
    }
    throw const Falha(
      TipoFalha.conflito,
      'Transição de solicitação não permitida.',
    );
  }
}
