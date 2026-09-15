import '../../domain/entities/pagamento_entity.dart';
import '../../domain/repositories/pagamento_repository.dart';
import '../datasources/pagamento_remote_datasource.dart';
import '../errors/executar_repositorio.dart';

class PagamentoRepositoryImpl implements PagamentoRepository {
  final PagamentoRemoteDataSource dataSource;
  PagamentoRepositoryImpl(this.dataSource);

  @override
  Future<PagamentoEntity?> buscarPorServicoId(String id) => executarRepositorio(
    () async => (await dataSource.buscar(id))?.toEntity(),
  );
}
