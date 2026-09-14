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
      fotoUrl: json['foto_url'] as String?,
      emailVerificado: json['email_verificado'] as bool? ?? false,
      ativo: json['ativo'] as bool? ?? true,
      ultimoLoginEm: json['ultimo_login_em'] != null
          ? DateTime.parse(json['ultimo_login_em'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.toString().split('.').last,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'foto_url': fotoUrl,
      'email_verificado': emailVerificado,
      'ativo': ativo,
      'ultimo_login_em': ultimoLoginEm?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UsuarioModel.fromEntity(UsuarioEntity entity) => UsuarioModel(
    id: entity.id,
    tipo: entity.tipo,
    nome: entity.nome,
    email: entity.email,
    telefone: entity.telefone,
    fotoUrl: entity.fotoUrl,
    emailVerificado: entity.emailVerificado,
    ativo: entity.ativo,
    ultimoLoginEm: entity.ultimoLoginEm,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
  UsuarioEntity toEntity() => UsuarioEntity(
    id: id,
    tipo: tipo,
    nome: nome,
    email: email,
    telefone: telefone,
    fotoUrl: fotoUrl,
    emailVerificado: emailVerificado,
    ativo: ativo,
    ultimoLoginEm: ultimoLoginEm,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
