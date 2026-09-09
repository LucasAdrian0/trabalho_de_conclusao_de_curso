import 'package:tcc_frete_urbano/domain/enums/status_orcamento.dart';


class OrcamentoEntity {
  final String id;
  final String freteId;
  final String prestadorId;
  final double valor;
  final String? observacao;
  final StatusOrcamento status;
  final DateTime criadoEm;
  final DateTime? atualizadoEm;

  const OrcamentoEntity({
    required this.id,
    required this.freteId,
    required this.prestadorId,
    required this.valor,
    this.observacao,
    required this.status,
    required this.criadoEm,
    this.atualizadoEm,
  });
}