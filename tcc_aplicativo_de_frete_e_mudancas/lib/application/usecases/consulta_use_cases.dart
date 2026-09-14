import '../../domain/entities/usuario_entity.dart';
import '../../domain/entities/pagamento_entity.dart';
import '../../domain/entities/notificacoes_entity.dart';
import '../../domain/entities/solicitacao_entity.dart';
import '../../domain/entities/servico_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/repositories/pagamento_repository.dart';
import '../../domain/repositories/notificacoes_repository.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../../domain/repositories/servico_repository.dart';
import '../support/sessao.dart';

class ConsultarMeuPerfil {
  final AuthRepository _auth;
  final UsuarioRepository _usuarios;
  const ConsultarMeuPerfil(this._auth, this._usuarios);
  Future<UsuarioEntity?> call() async =>
      _usuarios.buscarPorId(exigirUsuario(_auth));
}

class ConsultarPagamento {
  final AuthRepository _auth;
  final PagamentoRepository _pagamentos;
  const ConsultarPagamento(this._auth, this._pagamentos);
  Future<PagamentoEntity?> call(String servicoId) async {
    exigirUsuario(_auth);
    return _pagamentos.buscarPorServicoId(servicoId);
  }
}

class ListarMinhasNotificacoes {
  final AuthRepository _auth;
  final NotificacoesRepository _notificacoes;
  const ListarMinhasNotificacoes(this._auth, this._notificacoes);
  Future<List<NotificacoesEntity>> call() async =>
      _notificacoes.listarPorUsuarioId(exigirUsuario(_auth));
}

class MarcarNotificacaoComoLida {
  final AuthRepository _auth;
  final NotificacoesRepository _notificacoes;
  const MarcarNotificacaoComoLida(this._auth, this._notificacoes);
  Future<void> call(String id) async {
    exigirUsuario(_auth);
    await _notificacoes.marcarComoLida(id);
  }
}

class ListarMinhasSolicitacoes {
  final AuthRepository _auth;
  final SolicitacaoRepository _solicitacoes;
  const ListarMinhasSolicitacoes(this._auth, this._solicitacoes);
  Future<List<SolicitacaoEntity>> call() async =>
      _solicitacoes.listarPorClienteId(exigirUsuario(_auth));
}

class ListarServicosComoCliente {
  final AuthRepository _auth;
  final ServicoRepository _servicos;
  const ListarServicosComoCliente(this._auth, this._servicos);
  Future<List<ServicoEntity>> call() async =>
      _servicos.listarPorClienteId(exigirUsuario(_auth));
}

class ListarServicosComoPrestador {
  final AuthRepository _auth;
  final ServicoRepository _servicos;
  const ListarServicosComoPrestador(this._auth, this._servicos);
  Future<List<ServicoEntity>> call() async =>
      _servicos.listarPorPrestadorId(exigirUsuario(_auth));
}
