import 'package:tcc_frete_urbano/domain/entities/servico_entity.dart';
import 'package:tcc_frete_urbano/domain/enums/status_servico.dart';

abstract class ServicoRepository {
  Future<ServicoEntity?> buscarPorId(String id);
  Future<List<ServicoEntity>> listarPorClienteId(String clienteId);
  Future<List<ServicoEntity>> listarPorPrestadorId(String prestadorId);
  Future<void> criar(ServicoEntity servico);
  
  Future<void> atualizarStatus({
    required String servicoId,
    required StatusServico novoStatus, // <-- Alterado de String para StatusServico
    required String usuarioId,
    String? observacao,
  });
}