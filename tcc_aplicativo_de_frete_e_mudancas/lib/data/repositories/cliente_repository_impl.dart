import '../../domain/entities/cliente_entity.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_remote_datasource.dart';
import '../models/cliente_model.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remoteDataSource;

  ClienteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ClienteEntity?> buscarPorUsuarioId(String usuarioId) async {
    final clienteModel = await remoteDataSource.buscarPorUsuarioId(usuarioId);
    return clienteModel?.toEntity();
  }

  @override
  Future<ClienteEntity?> buscarPorCpf(String cpf) async {
    final clienteModel = await remoteDataSource.buscarPorCpf(cpf);
    return clienteModel?.toEntity();
  }

  @override
  Future<void> salvar(ClienteEntity cliente) async {
    final model = ClienteModel.fromEntity(cliente);
    await remoteDataSource.salvar(model);
  }

  @override
  Future<void> atualizar(ClienteEntity cliente) async {
    final model = ClienteModel.fromEntity(cliente);
    await remoteDataSource.atualizar(model);
  }
}
