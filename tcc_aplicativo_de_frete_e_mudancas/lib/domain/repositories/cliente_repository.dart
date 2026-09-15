import '../entities/cliente_entity.dart';

abstract class ClienteRepository {
  Future<ClienteEntity?> buscarPorUsuarioId(String id);
  Future<void> salvar(ClienteEntity cliente);
}
