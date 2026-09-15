import '../enums/tipo_usuario.dart';

class UsuarioEntity {
  final String id;
  final TipoUsuario tipo;
  final String nome;
  final String email;
  final String? telefone;
  final String? fotoPerfilUrl;
  final bool ativo;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  const UsuarioEntity({
    required this.id,
    required this.tipo,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoPerfilUrl,
    this.ativo = true,
    required this.criadoEm,
    required this.atualizadoEm,
  });
  bool validarEmail() => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  bool podeAutenticar() => ativo;
}
