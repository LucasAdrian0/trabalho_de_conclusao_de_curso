import '../errors/executar_repositorio.dart';
import 'package:tcc_frete_urbano/data/datasources/servico_remote_datasouce.dart';
import '../../domain/entities/servico_entity.dart';
import '../../domain/enums/status_servico.dart';
import '../../domain/repositories/servico_repository.dart';

class ServicoRepositoryImpl implements ServicoRepository {
  final ServicoRemoteDataSource remoteDataSource;

  ServicoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ServicoEntity?> buscarPorId(String id) =>
      executarRepositorio(() async {
        final model = await remoteDataSource.buscarPorId(id);
        return model?.toEntity();
      });

  @override
  Future<List<ServicoEntity>> listarPorClienteId(String clienteId) =>
      executarRepositorio(() async {
        final models = await remoteDataSource.listarPorClienteId(clienteId);
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<List<ServicoEntity>> listarPorPrestadorId(String prestadorId) =>
      executarRepositorio(() async {
        final models = await remoteDataSource.listarPorPrestadorId(prestadorId);
        return models.map((model) => model.toEntity()).toList();
      });

  @override
  Future<ServicoEntity> aceitarOrcamento(String orcamentoId) =>
      executarRepositorio(() async {
        return (await remoteDataSource.aceitarOrcamento(
          orcamentoId,
        )).toEntity();
      });

  @override
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus, // <-- Atualizado para StatusServico
    String? observacao,
  }) => executarRepositorio(() async {
    await remoteDataSource.atualizarStatus(
      servicoId: servicoId,
      novoStatus: novoStatus,
      observacao: observacao,
    );
  });
}
