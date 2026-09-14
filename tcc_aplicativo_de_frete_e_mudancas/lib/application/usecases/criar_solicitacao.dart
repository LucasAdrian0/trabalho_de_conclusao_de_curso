import '../../domain/entities/solicitacao_entity.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../support/sessao.dart';

class CriarSolicitacao {
  final AuthRepository _auth;
  final ClienteRepository _clientes;
  final SolicitacaoRepository _solicitacoes;
  const CriarSolicitacao(this._auth, this._clientes, this._solicitacoes);
  Future<void> call(SolicitacaoEntity solicitacao) async {
    final id = exigirUsuario(_auth);
    exigirProprietario(id, solicitacao.clienteId);
    solicitacao.validar();
    if (solicitacao.status != StatusSolicitacao.criado &&
        solicitacao.status != StatusSolicitacao.aguardandoPrestador) {
      throw const Falha(
        TipoFalha.validacao,
        'Estado inicial da solicitação inválido.',
      );
    }
    for (final endereco in [
      solicitacao.enderecoOrigem,
      solicitacao.enderecoDestino,
    ]) {
      if (endereco.usuarioId != null) {
        exigirProprietario(id, endereco.usuarioId!);
      }
    }
    final cliente = await _clientes.buscarPorUsuarioId(id);
    if (cliente == null || !cliente.podeSolicitarServico()) {
      throw const Falha(
        TipoFalha.validacao,
        'Complete seu cadastro e confirme o e-mail antes de solicitar.',
      );
    }
    // O contrato representa uma gravação atômica; não divide itens/endereços aqui.
    await _solicitacoes.salvar(solicitacao);
  }
}
