import 'package:tcc_frete_urbano/data/datasources/endereco_remote_datasouce.dart';
import '../../domain/entities/endereco_entity.dart';
import '../../domain/repositories/endereco_repository.dart';
import '../models/endereco_model.dart';

class EnderecoRepositoryImpl implements EnderecoRepository {
  final EnderecoRemoteDataSource remoteDataSource;

  EnderecoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EnderecoEntity>> listarPorUsuarioId(String usuarioId) async {
    final models = await remoteDataSource.listarPorUsuarioId(usuarioId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<EnderecoEntity?> buscarPorId(String id) async {
    final model = await remoteDataSource.buscarPorId(id);
    return model?.toEntity();
  }

  @override
  Future<void> salvar(EnderecoEntity endereco) async {
    final model = EnderecoModel.fromEntity(endereco);
    await remoteDataSource.salvar(model);
  }

  @override
  Future<void> atualizar(EnderecoEntity endereco) async {
    final model = EnderecoModel.fromEntity(endereco);
    await remoteDataSource.atualizar(model);
  }

  @override
  Future<void> deletar(String id) async {
    await remoteDataSource.deletar(id);
  }
}