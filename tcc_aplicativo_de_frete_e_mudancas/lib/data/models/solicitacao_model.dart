import 'package:tcc_frete_urbano/data/models/item_solicitado.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_servico_solicitado.dart';

import '../../domain/entities/solicitacao_entity.dart';
import 'endereco_model.dart';

class SolicitacaoModel extends SolicitacaoEntity {
  const SolicitacaoModel({
    required super.id,
    required super.clienteId,
    required super.enderecoOrigem,
    required super.enderecoDestino,
    required super.dataDesejada,
    required super.horarioDesejado,
    required super.tiposervico,
    required super.volumeEstimadoM3,
    super.necessitaAjudantes,
    super.quantidadeAjudantes,
    required super.distanciaKm,
    required super.duracaoEstimadaMin,
    required super.status,
    super.observacoes,
    super.itens,
  });

  factory SolicitacaoModel.fromJson(Map<String, dynamic> json) {
    return SolicitacaoModel(
      id: json['id'] as String,
      clienteId: json['cliente_id'] as String,
      enderecoOrigem: EnderecoModel.fromJson(
        json['endereco_origem'] as Map<String, dynamic>,
      ),
      enderecoDestino: EnderecoModel.fromJson(
        json['endereco_destino'] as Map<String, dynamic>,
      ),
      dataDesejada: DateTime.parse(json['data_desejada'] as String),
      horarioDesejado: json['horario_desejado'] as String,
      
      // Deserialização segura utilizando os métodos dos Enums
      tiposervico: TipoServicoSolicitado.fromString(
        json['tipo_servico'] as String?,
      ),
      status: StatusSolicitacao.fromString(
        json['status'] as String?,
      ),

      volumeEstimadoM3: (json['volume_estimado_m3'] as num).toDouble(),
      necessitaAjudantes: json['necessita_ajudantes'] as bool? ?? false,
      quantidadeAjudantes: json['quantidade_ajudantes'] as int? ?? 0,
      distanciaKm: (json['distancia_km'] as num).toDouble(),
      duracaoEstimadaMin: json['duracao_estimada_min'] as int,
      observacoes: json['observacoes'] as String?,
      itens: json['itens'] != null
          ? (json['itens'] as List)
              .map<ItemSolicitacaoModel>((e) =>
                  ItemSolicitacaoModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'origem_id': enderecoOrigem.id,
      'destino_id': enderecoDestino.id,
      'data_desejada': dataDesejada.toIso8601String(),
      'horario_desejado': horarioDesejado,
      
      // Serialização dos Enums
      'tipo_servico': tiposervico.name,
      'status': status.name,

      'volume_estimado_m3': volumeEstimadoM3,
      'necessita_ajudantes': necessitaAjudantes,
      'quantidade_ajudantes': quantidadeAjudantes,
      'distancia_km': distanciaKm,
      'duracao_estimada_min': duracaoEstimadaMin,
      if (observacoes != null) 'observacoes': observacoes,
    };
  }

  SolicitacaoEntity toEntity() => this;

  factory SolicitacaoModel.fromEntity(SolicitacaoEntity entity) {
    return SolicitacaoModel(
      id: entity.id,
      clienteId: entity.clienteId,
      enderecoOrigem: entity.enderecoOrigem,
      enderecoDestino: entity.enderecoDestino,
      dataDesejada: entity.dataDesejada,
      horarioDesejado: entity.horarioDesejado,
      tiposervico: entity.tiposervico,
      volumeEstimadoM3: entity.volumeEstimadoM3,
      necessitaAjudantes: entity.necessitaAjudantes,
      quantidadeAjudantes: entity.quantidadeAjudantes,
      distanciaKm: entity.distanciaKm,
      duracaoEstimadaMin: entity.duracaoEstimadaMin,
      status: entity.status,
      observacoes: entity.observacoes,
      itens: entity.itens,
    );
  }
}