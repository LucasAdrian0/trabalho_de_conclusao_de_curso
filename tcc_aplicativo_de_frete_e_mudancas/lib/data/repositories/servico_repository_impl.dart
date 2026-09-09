import 'package:tcc_frete_urbano/data/datasources/servico_remote_datasouce.dart';
import '../../domain/entities/servico_entity.dart';
import '../../domain/enums/status_servico.dart';
import '../../domain/repositories/servico_repository.dart';
import '../models/servico_model.dart';

class ServicoRepositoryImpl implements ServicoRepository {
  final ServicoRemoteDataSource remoteDataSource;

  ServicoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ServicoEntity?> buscarPorId(String id) async {
    final model = await remoteDataSource.buscarPorId(id);
    return model?.toEntity();
  }

  @override
  Future<List<ServicoEntity>> listarPorClienteId(String clienteId) async {
    final models = await remoteDataSource.listarPorClienteId(clienteId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ServicoEntity>> listarPorPrestadorId(String prestadorId) async {
    final models = await remoteDataSource.listarPorPrestadorId(prestadorId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> criar(ServicoEntity servico) async {
    final model = ServicoModel.fromEntity(servico);
    await remoteDataSource.criar(model);
  }

  @override
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus, // <-- Atualizado para StatusServico
    required String usuarioId,
    String? observacao,
  }) async {
    await remoteDataSource.atualizarStatus(
      servicoId: servicoId,
      novoStatus: novoStatus,
      usuarioId: usuarioId,
      observacao: observacao,
    );
  }
}