import '../../domain/entities/endereco_entity.dart';
import '../../domain/repositories/endereco_repository.dart';
import '../datasources/endereco_remote_datasource.dart';
import '../errors/executar_repositorio.dart';
import '../models/endereco_model.dart';

class EnderecoRepositoryImpl implements EnderecoRepository {
  final EnderecoRemoteDataSource dataSource;
  EnderecoRepositoryImpl(this.dataSource);

  @override
  Future<List<EnderecoEntity>> listarPorUsuarioId(String id) =>
      executarRepositorio(
        () async => (await dataSource.listar(
          id,
        )).map((model) => model.toEntity()).toList(),
      );
  @override
  Future<EnderecoEntity?> buscarPorId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
  @override
  Future<void> salvar(EnderecoEntity endereco) => executarRepositorio(
    () => dataSource.salvar(EnderecoModel.fromEntity(endereco)),
  );
  @override
  Future<void> excluir(String id) =>
      executarRepositorio(() => dataSource.excluir(id));
}
