import 'package:tcc_frete_urbano/domain/entities/item_solicitado.dart';

class ItemSolicitacaoModel extends ItemSolicitacao {
  const ItemSolicitacaoModel({
    required super.id,
    required super.solicitacaoId,
    required super.nome,
    required super.categoria,
    required super.quantidade,
    super.fragil,
    super.observacoes,
  });

  factory ItemSolicitacaoModel.fromJson(Map<String, dynamic> json) {
    return ItemSolicitacaoModel(
      id: json['id'] as String,
      solicitacaoId: json['solicitacao_id'] as String,
      nome: json['nome'] as String,
      categoria: json['categoria'] as String? ?? '',
      quantidade: json['quantidade'] as int,
      fragil: json['fragil'] as bool? ?? false,
      observacoes: json['observacoes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solicitacao_id': solicitacaoId,
      'nome': nome,
      'categoria': categoria,
      'quantidade': quantidade,
      'fragil': fragil,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }

  factory ItemSolicitacaoModel.fromEntity(ItemSolicitacao entity) {
    return ItemSolicitacaoModel(
      id: entity.id,
      solicitacaoId: entity.solicitacaoId,
      nome: entity.nome,
      categoria: entity.categoria,
      quantidade: entity.quantidade,
      fragil: entity.fragil,
      observacoes: entity.observacoes,
    );
  }
  ItemSolicitacao toEntity() => ItemSolicitacao(
    id: id,
    solicitacaoId: solicitacaoId,
    nome: nome,
    categoria: categoria,
    quantidade: quantidade,
    fragil: fragil,
    observacoes: observacoes,
  );
}
