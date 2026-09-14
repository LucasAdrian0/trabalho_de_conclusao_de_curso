import '../../domain/entities/avaliacao_entity.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/avaliacao_repository.dart';
import '../../domain/repositories/servico_repository.dart';
import '../support/sessao.dart';

class AvaliarServico {
  final AuthRepository _auth;
  final AvaliacaoRepository _avaliacoes;
  final ServicoRepository _servicos;
  const AvaliarServico(this._auth, this._avaliacoes, this._servicos);
  Future<void> call(AvaliacaoEntity avaliacao) async {
    final id = exigirUsuario(_auth);
    exigirProprietario(id, avaliacao.clienteId);
    avaliacao.validar();
    final servico = await _servicos.buscarPorId(avaliacao.servicoId);
    if (servico == null ||
        servico.clienteId != id ||
        servico.prestadorId != avaliacao.prestadorId ||
        !servico.podeAvaliar()) {
      throw const Falha(
        TipoFalha.conflito,
        'Somente o cliente pode avaliar seu serviço concluído.',
      );
    }
    await _avaliacoes.salvar(avaliacao);
  }
}
