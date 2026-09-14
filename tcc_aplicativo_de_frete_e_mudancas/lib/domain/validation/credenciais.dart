import '../errors/falha.dart';

abstract final class Credenciais {
  static String email(String valor) {
    final normalizado = valor.trim();
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(normalizado)) {
      throw const Falha(TipoFalha.validacao, 'E-mail inválido.');
    }
    return normalizado;
  }

  static void senhaCadastro(String valor) {
    if (valor.length < 8) {
      throw const Falha(
        TipoFalha.validacao,
        'A senha deve ter pelo menos 8 caracteres.',
      );
    }
  }

  static String textoObrigatorio(String valor, String campo) {
    if (valor.trim().isEmpty) {
      throw Falha(TipoFalha.validacao, 'Informe $campo.');
    }
    return valor.trim();
  }
}
