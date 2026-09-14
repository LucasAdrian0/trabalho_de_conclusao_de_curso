import '../../domain/entities/cliente_entity.dart';
import '../../domain/entities/prestador_entity.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/entities/veiculo.dart';
import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../../domain/repositories/prestador_repository.dart';
import '../../domain/repositories/usuario_repository.dart';
import '../../domain/repositories/veiculo_repository.dart';
import '../../domain/validation/credenciais.dart';
import '../support/sessao.dart';

class AtualizarPerfil {
  final AuthRepository _auth;
  final UsuarioRepository _usuarios;
  const AtualizarPerfil(this._auth, this._usuarios);
  Future<void> call(UsuarioEntity usuario) async {
    exigirProprietario(exigirUsuario(_auth), usuario.id);
    Credenciais.textoObrigatorio(usuario.nome, 'o nome');
    await _usuarios.atualizar(usuario);
  }
}

class CompletarCadastroCliente {
  final AuthRepository _auth;
  final ClienteRepository _clientes;
  const CompletarCadastroCliente(this._auth, this._clientes);
  Future<void> call(ClienteEntity cliente) async {
    exigirProprietario(exigirUsuario(_auth), cliente.usuario.id);
    if (!cliente.validarCpf()) {
      throw const Falha(TipoFalha.validacao, 'CPF inválido.');
    }
    await _clientes.salvar(cliente);
  }
}

class CadastrarPrestador {
  final AuthRepository _auth;
  final PrestadorRepository _prestadores;
  const CadastrarPrestador(this._auth, this._prestadores);
  Future<void> call(PrestadorEntity prestador) async {
    exigirProprietario(exigirUsuario(_auth), prestador.usuario.id);
    prestador.validarCadastro();
    await _prestadores.salvar(prestador);
  }
}

class AtualizarPrestador {
  final AuthRepository _auth;
  final PrestadorRepository _prestadores;
  const AtualizarPrestador(this._auth, this._prestadores);
  Future<void> call(PrestadorEntity prestador) async {
    exigirProprietario(exigirUsuario(_auth), prestador.usuario.id);
    prestador.validarCadastro();
    await _prestadores.atualizar(prestador);
  }
}

class SalvarVeiculo {
  final AuthRepository _auth;
  final VeiculoRepository _veiculos;
  const SalvarVeiculo(this._auth, this._veiculos);
  Future<void> call(Veiculo veiculo) async {
    exigirProprietario(exigirUsuario(_auth), veiculo.prestadorId);
    veiculo.validar();
    await _veiculos.salvar(veiculo);
  }
}
