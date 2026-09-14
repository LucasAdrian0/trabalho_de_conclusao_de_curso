import '../../domain/errors/falha.dart';
import '../../domain/repositories/auth_repository.dart';

String exigirUsuario(AuthRepository auth) {
  final id = auth.usuarioId;
  if (id == null) {
    throw const Falha(
      TipoFalha.naoAutenticado,
      'Entre na sua conta para continuar.',
    );
  }
  return id;
}

void exigirProprietario(String atual, String esperado) {
  if (atual != esperado) {
    throw const Falha(
      TipoFalha.acessoNegado,
      'Operação não autorizada para esta conta.',
    );
  }
}
