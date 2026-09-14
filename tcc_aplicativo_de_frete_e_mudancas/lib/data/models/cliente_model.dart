import 'package:tcc_frete_urbano/domain/entities/cliente_entity.dart';

import 'usuario_model.dart';

class ClienteModel extends ClienteEntity {
  const ClienteModel({required super.usuario, super.cpf});

  /// Converte o JSON do Supabase (com join em usuarios) para ClienteModel.
  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      usuario: json['usuarios'] != null
          ? UsuarioModel.fromJson(json['usuarios'] as Map<String, dynamic>)
          : UsuarioModel.fromJson(json),
      cpf: json['cpf'] as String?,
    );
  }

  /// Converte o objeto para Map/JSON para salvar na tabela 'clientes'.
  Map<String, dynamic> toJson() {
    return {'usuario_id': usuario.id, if (cpf != null) 'cpf': cpf};
  }

  /// Converte o Model para a Entidade pura do Domain.
  ClienteEntity toEntity() => ClienteEntity(
    usuario: UsuarioModel.fromEntity(usuario).toEntity(),
    cpf: cpf,
  );

  /// Cria um Model a partir de uma Entidade do Domain.
  factory ClienteModel.fromEntity(ClienteEntity cliente) {
    return ClienteModel(usuario: cliente.usuario, cpf: cliente.cpf);
  }
}
