import 'usuario_entity.dart';

class ClienteEntity {
  final UsuarioEntity usuario;
  final String? cpf;

  const ClienteEntity({required this.usuario, this.cpf});

  /// Valida o formato e os dígitos verificadores do CPF.
  bool validarCpf() {
    if (cpf == null || cpf!.isEmpty) return false;

    // Remove caracteres não numéricos
    final numeros = cpf!.replaceAll(RegExp(r'\D'), '');

    if (numeros.length != 11) return false;

    // Bloqueia CPFs com todos os dígitos iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(numeros)) return false;

    // Validação dos dígitos verificadores
    for (var t = 9; t < 11; t++) {
      var d = 0;
      for (var c = 0; c < t; c++) {
        d += int.parse(numeros[c]) * ((t + 1) - c);
      }
      d = ((10 * d) % 11) % 10;
      if (int.parse(numeros[t]) != d) return false;
    }

    return true;
  }

  /// Verifica se o cliente possui cadastro ativo, e-mail verificado e CPF válido.
  bool podeSolicitarServico() {
    return usuario.podeAutenticar() && validarCpf();
  }
}
