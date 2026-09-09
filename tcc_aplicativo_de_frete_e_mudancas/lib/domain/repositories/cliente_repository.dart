import '../entities/cliente_entity.dart';

abstract class ClienteRepository {
  Future<ClienteEntity?> buscarPorUsuarioId(String usuarioId);
  Future<ClienteEntity?> buscarPorCpf(String cpf);
  Future<void> salvar(ClienteEntity cliente);
  Future<void> atualizar(ClienteEntity cliente);
}
