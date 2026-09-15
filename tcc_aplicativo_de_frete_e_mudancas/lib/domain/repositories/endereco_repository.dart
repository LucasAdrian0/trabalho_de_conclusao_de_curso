import '../entities/endereco_entity.dart';

abstract class EnderecoRepository {
  Future<List<EnderecoEntity>> listarPorUsuarioId(String id);
  Future<EnderecoEntity?> buscarPorId(String id);
  Future<void> salvar(EnderecoEntity endereco);
  Future<void> excluir(String id);
}
