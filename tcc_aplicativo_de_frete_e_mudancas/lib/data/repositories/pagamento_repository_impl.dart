import '../errors/executar_repositorio.dart';
import '../../domain/entities/pagamento_entity.dart';
import '../../domain/repositories/pagamento_repository.dart';
import '../datasources/pagamento_remote_datasouce.dart';

class PagamentoRepositoryImpl implements PagamentoRepository {
  final PagamentoRemoteDataSource remoteDataSource;
  PagamentoRepositoryImpl({required this.remoteDataSource});
  @override
  Future<PagamentoEntity?> buscarPorServicoId(String servicoId) =>
      executarRepositorio(() async {
        return (await remoteDataSource.buscarPorServicoId(
          servicoId,
        ))?.toEntity();
      });
}
