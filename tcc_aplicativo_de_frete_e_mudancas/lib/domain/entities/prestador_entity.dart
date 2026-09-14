import '../errors/falha.dart';
import '../enums/tipo_usuario.dart';
import '../enums/status_disponibilidade.dart';
import 'ajudantes_prestador.dart';
import 'regiao_atendimento.dart';
import 'usuario_entity.dart';
import 'veiculo.dart';

class PrestadorEntity {
  final UsuarioEntity usuario;
  final String cpfCnpj;
  final StatusDisponibilidade statusDisponibilidade;
  final double avaliacaoMedia;
  final int totalAvaliacoes;
  final int totalServicosConcluidos;
  final List<RegiaoAtendimento> regioesAtendimento;
  final List<Veiculo> veiculos;
  final AjudantesPrestador? servicoAjudantes;

  const PrestadorEntity({
    required this.usuario,
    required this.cpfCnpj,
    this.statusDisponibilidade = StatusDisponibilidade.disponivel,
    this.avaliacaoMedia = 0.0,
    this.totalAvaliacoes = 0,
    this.totalServicosConcluidos = 0,
    this.regioesAtendimento = const [],
    this.veiculos = const [],
    this.servicoAjudantes,
  });

  bool estaDisponivel() =>
      statusDisponibilidade == StatusDisponibilidade.disponivel;

  bool estaIndisponivel() =>
      statusDisponibilidade == StatusDisponibilidade.indisponivel;

  bool validarCpfCnpj() {
    final digitos = cpfCnpj.replaceAll(RegExp(r'\D'), '');
    return digitos.length == 11 || digitos.length == 14;
  }

  bool atendeRegiao(String cidade, String estado) {
    return regioesAtendimento.any(
      (regiao) => regiao.abrangeLocalizacao(cidade, estado),
    );
  }

  PrestadorEntity alterarDisponibilidade(
    StatusDisponibilidade novaDisponibilidade,
  ) {
    return copyWith(statusDisponibilidade: novaDisponibilidade);
  }

  PrestadorEntity recalcularMediaAvaliacoes(double novaNota) {
    final novoTotal = totalAvaliacoes + 1;
    final novaMedia =
        ((avaliacaoMedia * totalAvaliacoes) + novaNota) / novoTotal;
    return copyWith(avaliacaoMedia: novaMedia, totalAvaliacoes: novoTotal);
  }

  PrestadorEntity copyWith({
    UsuarioEntity? usuario,
    String? cpfCnpj,
    StatusDisponibilidade? statusDisponibilidade,
    double? avaliacaoMedia,
    int? totalAvaliacoes,
    int? totalServicosConcluidos,
    List<RegiaoAtendimento>? regioesAtendimento,
    List<Veiculo>? veiculos,
    AjudantesPrestador? servicoAjudantes,
  }) {
    return PrestadorEntity(
      usuario: usuario ?? this.usuario,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      statusDisponibilidade:
          statusDisponibilidade ?? this.statusDisponibilidade,
      avaliacaoMedia: avaliacaoMedia ?? this.avaliacaoMedia,
      totalAvaliacoes: totalAvaliacoes ?? this.totalAvaliacoes,
      totalServicosConcluidos:
          totalServicosConcluidos ?? this.totalServicosConcluidos,
      regioesAtendimento: regioesAtendimento ?? this.regioesAtendimento,
      veiculos: veiculos ?? this.veiculos,
      servicoAjudantes: servicoAjudantes ?? this.servicoAjudantes,
    );
  }

  void validarCadastro() {
    if (usuario.tipo != TipoUsuario.prestador || !validarCpfCnpj()) {
      throw const Falha(
        TipoFalha.validacao,
        'Informe um perfil de prestador com CPF/CNPJ válido.',
      );
    }
    for (final regiao in regioesAtendimento) {
      if (regiao.prestadorId != usuario.id ||
          regiao.cidade.trim().isEmpty ||
          regiao.estado.trim().length != 2 ||
          !regiao.raioKm.isFinite ||
          regiao.raioKm < 0) {
        throw const Falha(
          TipoFalha.validacao,
          'Região de atendimento inválida.',
        );
      }
    }
    for (final veiculo in veiculos) {
      veiculo.validar();
      if (veiculo.prestadorId != usuario.id) {
        throw const Falha(TipoFalha.validacao, 'Veículo de outro prestador.');
      }
    }
    final ajudantes = servicoAjudantes;
    if (ajudantes != null) {
      ajudantes.validar();
      if (ajudantes.prestadorId != usuario.id) {
        throw const Falha(TipoFalha.validacao, 'Ajudantes de outro prestador.');
      }
    }
  }
}
