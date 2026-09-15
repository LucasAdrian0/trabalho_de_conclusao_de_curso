import '../../domain/entities/cliente_entity.dart';
import 'usuario_model.dart';

class ClienteModel extends ClienteEntity {
  const ClienteModel({required super.usuario, super.cpf});
  factory ClienteModel.fromJson(Map<String, dynamic> j) => ClienteModel(
    usuario: UsuarioModel.fromJson(
      (j['usuarios'] ?? j) as Map<String, dynamic>,
    ),
    cpf: j['cpf'],
  );
  Map<String, dynamic> toJson() => {'usuario_id': usuario.id, 'cpf': cpf};
  ClienteEntity toEntity() => ClienteEntity(
    usuario: UsuarioModel.fromEntity(usuario).toEntity(),
    cpf: cpf,
  );
  factory ClienteModel.fromEntity(ClienteEntity e) =>
      ClienteModel(usuario: e.usuario, cpf: e.cpf);
}
