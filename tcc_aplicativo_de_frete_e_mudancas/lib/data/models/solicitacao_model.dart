import '../../domain/entities/solicitacao_entity.dart';
import '../mappers/database_enums.dart';
import 'endereco_model.dart';
import 'item_mudanca_model.dart';

class SolicitacaoModel extends SolicitacaoEntity {
  const SolicitacaoModel({
    required super.id,
    required super.clienteId,
    required super.enderecoOrigem,
    required super.enderecoDestino,
    required super.dataDesejada,
    required super.tipoServico,
    super.volumeEstimadoM3,
    super.necessitaAjudantes,
    super.quantidadeAjudantes,
    super.distanciaKm,
    super.rotaGeoJson,
    required super.status,
    required super.criadoEm,
    required super.atualizadoEm,
    super.itens,
  });
  factory SolicitacaoModel.fromJson(Map<String, dynamic> j) => SolicitacaoModel(
    id: j['id'],
    clienteId: j['cliente_id'],
    enderecoOrigem: EnderecoModel.fromJson(j['endereco_origem']),
    enderecoDestino: EnderecoModel.fromJson(j['endereco_destino']),
    dataDesejada: DateTime.parse(j['data_desejada']),
    tipoServico: TipoServicoSolicitadoMapper.fromDatabase(j['tipo_servico']),
    volumeEstimadoM3: (j['volume_estimado_m3'] as num?)?.toDouble(),
    necessitaAjudantes: j['necessita_ajudantes'] ?? false,
    quantidadeAjudantes: j['quantidade_ajudantes'] ?? 0,
    distanciaKm: (j['distancia_km'] as num?)?.toDouble(),
    rotaGeoJson: j['rota_geojson'] == null
        ? null
        : Map<String, dynamic>.from(j['rota_geojson']),
    status: StatusSolicitacaoMapper.fromDatabase(j['status']),
    criadoEm: DateTime.parse(j['criado_em']),
    atualizadoEm: DateTime.parse(j['atualizado_em']),
    itens: ((j['itens'] ?? []) as List)
        .map((e) => ItemMudancaModel.fromJson(e).toEntity())
        .toList(),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'cliente_id': clienteId,
    'endereco_origem_id': enderecoOrigem.id,
    'endereco_destino_id': enderecoDestino.id,
    'data_desejada': dataDesejada.toIso8601String().split('T').first,
    'tipo_servico': tipoServico.databaseValue,
    'volume_estimado_m3': volumeEstimadoM3,
    'necessita_ajudantes': necessitaAjudantes,
    'quantidade_ajudantes': quantidadeAjudantes,
    'distancia_km': distanciaKm,
    'rota_geojson': rotaGeoJson,
    'status': status.databaseValue,
    'criado_em': criadoEm.toIso8601String(),
    'atualizado_em': atualizadoEm.toIso8601String(),
  };
  SolicitacaoEntity toEntity() => SolicitacaoEntity(
    id: id,
    clienteId: clienteId,
    enderecoOrigem: EnderecoModel.fromEntity(enderecoOrigem).toEntity(),
    enderecoDestino: EnderecoModel.fromEntity(enderecoDestino).toEntity(),
    dataDesejada: dataDesejada,
    tipoServico: tipoServico,
    volumeEstimadoM3: volumeEstimadoM3,
    necessitaAjudantes: necessitaAjudantes,
    quantidadeAjudantes: quantidadeAjudantes,
    distanciaKm: distanciaKm,
    rotaGeoJson: rotaGeoJson,
    status: status,
    criadoEm: criadoEm,
    atualizadoEm: atualizadoEm,
    itens: itens.map((e) => ItemMudancaModel.fromEntity(e).toEntity()).toList(),
  );
  factory SolicitacaoModel.fromEntity(SolicitacaoEntity e) => SolicitacaoModel(
    id: e.id,
    clienteId: e.clienteId,
    enderecoOrigem: e.enderecoOrigem,
    enderecoDestino: e.enderecoDestino,
    dataDesejada: e.dataDesejada,
    tipoServico: e.tipoServico,
    volumeEstimadoM3: e.volumeEstimadoM3,
    necessitaAjudantes: e.necessitaAjudantes,
    quantidadeAjudantes: e.quantidadeAjudantes,
    distanciaKm: e.distanciaKm,
    rotaGeoJson: e.rotaGeoJson,
    status: e.status,
    criadoEm: e.criadoEm,
    atualizadoEm: e.atualizadoEm,
    itens: e.itens,
  );
}
