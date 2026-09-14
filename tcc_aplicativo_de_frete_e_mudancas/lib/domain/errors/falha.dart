enum TipoFalha {
  validacao,
  naoAutenticado,
  acessoNegado,
  naoEncontrado,
  conflito,
  indisponivel,
  dadosInvalidos,
  inesperada,
}

/// Erro independente de Flutter, HTTP e banco de dados.
class Falha implements Exception {
  final TipoFalha tipo;
  final String mensagem;
  const Falha(this.tipo, this.mensagem);
  @override
  String toString() => mensagem;
}
