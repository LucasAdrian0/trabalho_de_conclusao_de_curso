import 'package:tcc_frete_urbano/domain/enums/tipo_usuario.dart';

class UsuarioEntity {
  final String id;
  final TipoUsuario tipo;
  final String nome;
  final String email;
  final String? telefone;
  final String? fotoUrl;
  final bool emailVerificado;
  final bool ativo;
  final DateTime? ultimoLoginEm;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UsuarioEntity({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoUrl,
    this.emailVerificado = false,
    this.ativo = true,
    this.ultimoLoginEm,
    required this.createdAt,
    required this.updatedAt,
  });

  // Regras de negócio do domínio
  bool validarEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  bool validarTelefone() {
    if (telefone == null || telefone!.isEmpty) return false;
    final apenasDigitos = telefone!.replaceAll(RegExp(r'\D'), '');
    return apenasDigitos.length >= 10 && apenasDigitos.length <= 11;
  }

  bool podeAutenticar() => ativo && emailVerificado;
}
