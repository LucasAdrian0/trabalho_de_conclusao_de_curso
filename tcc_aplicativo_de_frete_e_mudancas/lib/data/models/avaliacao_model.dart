import '../../domain/entities/avaliacao_entity.dart';

class AvaliacaoModel extends AvaliacaoEntity {
  const AvaliacaoModel({
    required super.id,
    required super.servicoId,
    required super.clienteId,
    required super.prestadorId,
    required super.nota,
    super.comentario,
    required super.criadoEm,
  });
  factory AvaliacaoModel.fromJson(Map<String, dynamic> j) => AvaliacaoModel(
    id: j['id'],
    servicoId: j['servico_id'],
    clienteId: j['cliente_id'],
    prestadorId: j['prestador_id'],
    nota: j['nota'],
    comentario: j['comentario'],
    criadoEm: DateTime.parse(j['criado_em']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'servico_id': servicoId,
    'cliente_id': clienteId,
    'prestador_id': prestadorId,
    'nota': nota,
    'comentario': comentario,
    'criado_em': criadoEm.toIso8601String(),
  };
  AvaliacaoEntity toEntity() => AvaliacaoEntity(
    id: id,
    servicoId: servicoId,
    clienteId: clienteId,
    prestadorId: prestadorId,
    nota: nota,
    comentario: comentario,
    criadoEm: criadoEm,
  );
  factory AvaliacaoModel.fromEntity(AvaliacaoEntity e) => AvaliacaoModel(
    id: e.id,
    servicoId: e.servicoId,
    clienteId: e.clienteId,
    prestadorId: e.prestadorId,
    nota: e.nota,
    comentario: e.comentario,
    criadoEm: e.criadoEm,
  );
}
