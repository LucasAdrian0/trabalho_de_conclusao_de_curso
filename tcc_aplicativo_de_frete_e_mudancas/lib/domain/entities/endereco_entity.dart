import '../enums/tipo_endereco.dart';

class EnderecoEntity {
  final String id;
  final String usuarioId;
  final TipoEndereco tipo;
  final String cep;
  final String logradouro;
  final String numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final double? latitude;
  final double? longitude;
  final bool temElevador;
  final int andar;

  const EnderecoEntity({
    required this.id,
    required this.usuarioId,
    required this.tipo,
    required this.cep,
    required this.logradouro,
    required this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.latitude,
    this.longitude,
    this.temElevador = false,
    this.andar = 0,
  });

  bool temGeolocalizacaoValida() {
    return latitude != null && longitude != null;
  }

  bool eEnderecoOrigem() => tipo == TipoEndereco.origem;

  bool eEnderecoDestino() => tipo == TipoEndereco.destino;

  String formatarEnderecoCompleto() {
    final comp = (complemento != null && complemento!.isNotEmpty) ? ', $complemento' : '';
    return '$logradouro, $numero$comp - $bairro, $cidade - $estado, $cep';
  }
}