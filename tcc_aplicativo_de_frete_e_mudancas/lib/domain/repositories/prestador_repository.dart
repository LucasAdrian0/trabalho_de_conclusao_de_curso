import 'package:tcc_frete_urbano/domain/enums/status_disponibilidade.dart';

import '../entities/prestador_entity.dart';

abstract class PrestadorRepository {
  Future<PrestadorEntity?> buscarPorUsuarioId(String usuarioId);
  Future<List<PrestadorEntity>> buscarDisponiveisPorRegiao(
    String cidade,
    String estado,
  );
  Future<void> salvar(PrestadorEntity prestador);
  Future<void> atualizar(PrestadorEntity prestador);
  Future<void> alterarDisponibilidade(
    String usuarioId,
    StatusDisponibilidade disponivel,
  );
}
