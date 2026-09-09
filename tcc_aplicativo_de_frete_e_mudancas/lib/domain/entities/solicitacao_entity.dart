import 'package:tcc_frete_urbano/domain/entities/endereco_entity.dart';
import 'package:tcc_frete_urbano/domain/entities/item_solicitado.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_servico_solicitado.dart';

class SolicitacaoEntity {
  final String id;
  final String clienteId;
  final EnderecoEntity enderecoOrigem;
  final EnderecoEntity enderecoDestino;
  final DateTime dataDesejada;
  final String horarioDesejado;
  final TipoServicoSolicitado tiposervico;
  final double volumeEstimadoM3;
  final bool necessitaAjudantes;
  final int quantidadeAjudantes;
  final double distanciaKm;
  final int duracaoEstimadaMin;
  final StatusSolicitacao status;
  final String? observacoes;
  final List<ItemSolicitacao> itens;

  const SolicitacaoEntity({
    required this.id,
    required this.clienteId,
    required this.enderecoOrigem,
    required this.enderecoDestino,
    required this.dataDesejada,
    required this.horarioDesejado,
    required this.tiposervico,
    required this.volumeEstimadoM3,
    this.necessitaAjudantes = false,
    this.quantidadeAjudantes = 0,
    required this.distanciaKm,
    required this.duracaoEstimadaMin,
    required this.status,
    this.observacoes,
    this.itens = const [],
  });

  // Regras de negócio tipadas com Enum
  bool podeSerCancelada() => status == StatusSolicitacao.criado || status == StatusSolicitacao.aguardandoPrestador;

  bool podeReceberOrcamento() => status == StatusSolicitacao.aguardandoPrestador;

  SolicitacaoEntity expirar() {
    return _copyWith(status: StatusSolicitacao.expirada);
  }

  SolicitacaoEntity adicionarItem(ItemSolicitacao item) {
    final novosItens = List<ItemSolicitacao>.from(itens)..add(item);
    return _copyWith(itens: novosItens);
  }

  SolicitacaoEntity removerItem(String itemId) {
    final novosItens = itens.where((item) => item.id != itemId).toList();
    return _copyWith(itens: novosItens);
  }

  SolicitacaoEntity _copyWith({
    StatusSolicitacao? status,
    List<ItemSolicitacao>? itens,
  }) {
    return SolicitacaoEntity(
      id: id,
      clienteId: clienteId,
      enderecoOrigem: enderecoOrigem,
      enderecoDestino: enderecoDestino,
      dataDesejada: dataDesejada,
      horarioDesejado: horarioDesejado,
      tiposervico: tiposervico,
      volumeEstimadoM3: volumeEstimadoM3,
      necessitaAjudantes: necessitaAjudantes,
      quantidadeAjudantes: quantidadeAjudantes,
      distanciaKm: distanciaKm,
      duracaoEstimadaMin: duracaoEstimadaMin,
      status: status ?? this.status,
      observacoes: observacoes,
      itens: itens ?? this.itens,
    );
  }
}