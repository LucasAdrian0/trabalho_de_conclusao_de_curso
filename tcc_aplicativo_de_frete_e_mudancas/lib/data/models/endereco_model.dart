import '../mappers/database_enums.dart';
import '../../domain/entities/endereco_entity.dart';

class EnderecoModel extends EnderecoEntity {
  const EnderecoModel({
    required super.id,
    required super.usuarioId,
    required super.tipo,
    required super.cep,
    required super.logradouro,
    required super.numero,
    super.complemento,
    required super.bairro,
    required super.cidade,
    required super.estado,
    super.latitude,
    super.longitude,
    super.temElevador,
    super.andar,
  });

  factory EnderecoModel.fromJson(Map<String, dynamic> json) {
    return EnderecoModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String?,
      tipo: TipoEnderecoMapper.fromDatabase(json['tipo'] as String?),
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String,
      numero: json['numero'] as String? ?? '',
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String? ?? '',
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      temElevador: json['tem_elevador'] as bool? ?? false,
      andar: json['andar'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'tipo': tipo.name,
      'cep': cep,
      'logradouro': logradouro,
      'numero': numero,
      if (complemento != null) 'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'tem_elevador': temElevador,
      'andar': andar,
    };
  }

  EnderecoEntity toEntity() => EnderecoEntity(
    id: id,
    usuarioId: usuarioId,
    tipo: tipo,
    cep: cep,
    logradouro: logradouro,
    numero: numero,
    complemento: complemento,
    bairro: bairro,
    cidade: cidade,
    estado: estado,
    latitude: latitude,
    longitude: longitude,
    temElevador: temElevador,
    andar: andar,
  );

  factory EnderecoModel.fromEntity(EnderecoEntity entity) {
    return EnderecoModel(
      id: entity.id,
      usuarioId: entity.usuarioId,
      tipo: entity.tipo,
      cep: entity.cep,
      logradouro: entity.logradouro,
      numero: entity.numero,
      complemento: entity.complemento,
      bairro: entity.bairro,
      cidade: entity.cidade,
      estado: entity.estado,
      latitude: entity.latitude,
      longitude: entity.longitude,
      temElevador: entity.temElevador,
      andar: entity.andar,
    );
  }
}
