import '../../domain/enums/status_servico.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/servico_repository.dart';
import '../support/sessao.dart';

class AtualizarStatusServico {
  final AuthRepository _auth;
  final ServicoRepository _servicos;
  const AtualizarStatusServico(this._auth, this._servicos);
  Future<void> call({
    required String servicoId,
    required StatusServico novoStatus,
    String? observacao,
  }) async {
    final id = exigirUsuario(_auth);
    final servico = await _servicos.buscarPorId(servicoId);
    if (servico == null) {
      throw const Falha(TipoFalha.naoEncontrado, 'Serviço não encontrado.');
    }
    servico.validarTransicao(novoStatus, id);
    await _servicos.atualizarStatus(
      servicoId: servicoId,
      novoStatus: novoStatus,
      observacao: observacao,
    );
  }
}
