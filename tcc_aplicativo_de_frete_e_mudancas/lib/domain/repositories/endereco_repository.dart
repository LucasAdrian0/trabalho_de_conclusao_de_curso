import '../entities/endereco_entity.dart';

abstract class EnderecoRepository {
  Future<List<EnderecoEntity>> listarPorUsuarioId(String usuarioId);
  Future<EnderecoEntity?> buscarPorId(String id);
  Future<void> salvar(EnderecoEntity endereco);
  Future<void> atualizar(EnderecoEntity endereco);
  Future<void> deletar(String id);
}