import 'package:tcc_frete_urbano/data/datasources/pagamento_remote_datasouce.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';
import '../../domain/entities/pagamento_entity.dart';
import '../../domain/repositories/pagamento_repository.dart';
import '../models/pagamento_model.dart';

class PagamentoRepositoryImpl implements PagamentoRepository {
  final PagamentoRemoteDataSource remoteDataSource;

  PagamentoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PagamentoEntity?> buscarPorServicoId(String servicoId) async {
    final model = await remoteDataSource.buscarPorServicoId(servicoId);
    return model?.toEntity();
  }

  @override
  Future<void> registrar(PagamentoEntity pagamento) async {
    final model = PagamentoModel.fromEntity(pagamento);
    await remoteDataSource.registrar(model);
  }

  @override
  Future<void> atualizarStatus({
    required String pagamentoId,
    required StatusPagamento status,
    DateTime? dataConfirmacao,
  }) async {
    await remoteDataSource.atualizarStatus(
      pagamentoId,
      status,
      dataConfirmacao: dataConfirmacao,
    );
  }
}