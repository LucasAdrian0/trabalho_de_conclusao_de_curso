import '../../domain/entities/usuario_entity.dart';
import '../mappers/database_enums.dart';

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.tipo,
    required super.nome,
    required super.email,
    super.telefone,
    super.fotoPerfilUrl,
    super.ativo,
    required super.criadoEm,
    required super.atualizadoEm,
  });
  factory UsuarioModel.fromJson(Map<String, dynamic> j) => UsuarioModel(
    id: j['id'],
    tipo: TipoUsuarioMapper.fromDatabase(j['tipo']),
    nome: j['nome'],
    email: j['email'],
    telefone: j['telefone'],
    fotoPerfilUrl: j['foto_perfil_url'],
    ativo: j['ativo'] ?? true,
    criadoEm: DateTime.parse(j['criado_em']),
    atualizadoEm: DateTime.parse(j['atualizado_em']),
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'tipo': tipo.databaseValue,
    'nome': nome,
    'email': email,
    'telefone': telefone,
    'foto_perfil_url': fotoPerfilUrl,
    'ativo': ativo,
    'criado_em': criadoEm.toIso8601String(),
    'atualizado_em': atualizadoEm.toIso8601String(),
  };
  UsuarioEntity toEntity() => UsuarioEntity(
    id: id,
    tipo: tipo,
    nome: nome,
    email: email,
    telefone: telefone,
    fotoPerfilUrl: fotoPerfilUrl,
    ativo: ativo,
    criadoEm: criadoEm,
    atualizadoEm: atualizadoEm,
  );
  factory UsuarioModel.fromEntity(UsuarioEntity e) => UsuarioModel(
    id: e.id,
    tipo: e.tipo,
    nome: e.nome,
    email: e.email,
    telefone: e.telefone,
    fotoPerfilUrl: e.fotoPerfilUrl,
    ativo: e.ativo,
    criadoEm: e.criadoEm,
    atualizadoEm: e.atualizadoEm,
  );
}
