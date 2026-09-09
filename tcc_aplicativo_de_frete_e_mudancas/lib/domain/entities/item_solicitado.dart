class ItemSolicitacao {
  final String id;
  final String solicitacaoId;
  final String nome;
  final String categoria;
  final int quantidade;
  final bool fragil;
  final String? observacoes;

  const ItemSolicitacao({
    required this.id,
    required this.solicitacaoId,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    this.fragil = false,
    this.observacoes,
  });

  ItemSolicitacao marcarComoFragil() {
    return ItemSolicitacao(
      id: id,
      solicitacaoId: solicitacaoId,
      nome: nome,
      categoria: categoria,
      quantidade: quantidade,
      fragil: true,
      observacoes: observacoes,
    );
  }
}