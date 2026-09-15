import '../enums/tipo_endereco.dart';

class EnderecoEntity {
  final String id;
  final String usuarioId;
  final TipoEndereco tipo;
  final String logradouro;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String cidade;
  final String estado;
  final String? cep;
  final double? latitude;
  final double? longitude;
  final DateTime criadoEm;

  const EnderecoEntity({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.logradouro,
    this.numero,
    this.complemento,
    this.bairro,
    required this.cidade,
    required this.estado,
    this.cep,
    this.latitude,
    this.longitude,
    required this.criadoEm,
  });
  bool temGeolocalizacaoValida() =>
      latitude != null &&
      longitude != null &&
      latitude! >= -90 &&
      latitude! <= 90 &&
      longitude! >= -180 &&
      longitude! <= 180;
}
