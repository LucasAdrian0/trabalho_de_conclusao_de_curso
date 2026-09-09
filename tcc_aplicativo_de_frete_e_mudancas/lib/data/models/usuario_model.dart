import 'package:tcc_frete_urbano/domain/entities/usuario_entity.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_usuario.dart';

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.tipo,
    required super.nome,
    required super.email,
    super.telefone,
    super.fotoUrl,
    super.emailVerificado,
    super.ativo,
    super.ultimoLoginEm,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String,
      tipo: TipoUsuario.values.firstWhere(
        (e) => e.toString() == 'TipoUsuario.${json['tipo']}',
      ),
      nome: json['nome'] as String,
      email: json['email'] as String,
      telefone: json['telefone'] as String?,
      fotoUrl: json['fotoUrl'] as String?,
      emailVerificado: json['emailVerificado'] as bool? ?? false,
      ativo: json['ativo'] as bool? ?? true,
      ultimoLoginEm: json['ultimoLoginEm'] != null
          ? DateTime.parse(json['ultimoLoginEm'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.toString().split('.').last,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'fotoUrl': fotoUrl,
      'emailVerificado': emailVerificado,
      'ativo': ativo,
      'ultimoLoginEm': ultimoLoginEm?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
