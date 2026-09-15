import '../../domain/entities/item_mudanca_entity.dart';

class ItemMudancaModel extends ItemMudancaEntity {
  const ItemMudancaModel({
    required super.id,
    required super.solicitacaoId,
    required super.descricao,
    required super.quantidade,
    super.volumeM3,
  });
  factory ItemMudancaModel.fromJson(Map<String, dynamic> j) => ItemMudancaModel(
    id: j['id'],
    solicitacaoId: j['solicitacao_id'],
    descricao: j['descricao'],
    quantidade: j['quantidade'],
    volumeM3: (j['volume_m3'] as num?)?.toDouble(),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'solicitacao_id': solicitacaoId,
    'descricao': descricao,
    'quantidade': quantidade,
    'volume_m3': volumeM3,
  };
  ItemMudancaEntity toEntity() => ItemMudancaEntity(
    id: id,
    solicitacaoId: solicitacaoId,
    descricao: descricao,
    quantidade: quantidade,
    volumeM3: volumeM3,
  );
  factory ItemMudancaModel.fromEntity(ItemMudancaEntity e) => ItemMudancaModel(
    id: e.id,
    solicitacaoId: e.solicitacaoId,
    descricao: e.descricao,
    quantidade: e.quantidade,
    volumeM3: e.volumeM3,
  );
}
