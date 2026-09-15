import '../enums/status_disponibilidade.dart';
import '../enums/tipo_usuario.dart';
import '../errors/falha.dart';
import 'usuario_entity.dart';

class PrestadorEntity {
  final UsuarioEntity usuario;
  final String? cpfCnpj;
  final String? regiaoAtendimento;
  final StatusDisponibilidade statusDisponibilidade;
  final double avaliacaoMedia;
  final int totalAvaliacoes;

  const PrestadorEntity({
    required this.usuario,
    this.cpfCnpj,
    this.regiaoAtendimento,
    this.statusDisponibilidade = StatusDisponibilidade.indisponivel,
    this.avaliacaoMedia = 0,
    this.totalAvaliacoes = 0,
  });
  bool estaDisponivel() =>
      statusDisponibilidade == StatusDisponibilidade.disponivel;
  void validarCadastro() {
    final documento = cpfCnpj?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (usuario.tipo != TipoUsuario.prestador ||
        (documento.length != 11 && documento.length != 14)) {
      throw const Falha(TipoFalha.validacao, 'CPF/CNPJ do prestador inválido.');
    }
    if (!avaliacaoMedia.isFinite ||
        avaliacaoMedia < 0 ||
        avaliacaoMedia > 5 ||
        totalAvaliacoes < 0) {
      throw const Falha(
        TipoFalha.validacao,
        'Avaliação do prestador inválida.',
      );
    }
  }
}
