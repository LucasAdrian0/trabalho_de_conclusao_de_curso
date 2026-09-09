import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_frete_urbano/domain/enums/status_disponibilidade.dart';
import '../models/prestador_model.dart';

abstract class PrestadorRemoteDataSource {
  Future<PrestadorModel?> buscarPorUsuarioId(String usuarioId);
  Future<List<PrestadorModel>> buscarDisponiveisPorRegiao(
    String cidade,
    String estado,
  );
  Future<void> salvar(PrestadorModel prestador);
  Future<void> atualizar(PrestadorModel prestador);
  Future<void> alterarDisponibilidade(
    String usuarioId,
    StatusDisponibilidade disponivel,
  );
}

class PrestadorRemoteDataSourceImpl implements PrestadorRemoteDataSource {
  final SupabaseClient supabase;

  PrestadorRemoteDataSourceImpl({required this.supabase});

  @override
  Future<PrestadorModel?> buscarPorUsuarioId(String usuarioId) async {
    final response = await supabase
        .from('prestadores')
        .select(
          '*, usuarios(*), regioes_atendimento(*), veiculos(*), ajudantes(*)',
        )
        .eq('usuario_id', usuarioId)
        .maybeSingle();

    if (response == null) return null;
    return PrestadorModel.fromJson(response);
  }

  @override
  Future<List<PrestadorModel>> buscarDisponiveisPorRegiao(
    String cidade,
    String estado,
  ) async {
    final response = await supabase
        .from('prestadores')
        .select(
          '*, usuarios(*), regioes_atendimento(*), veiculos(*), ajudantes(*)',
        )
        // Filtra pela string 'disponivel' correspondente ao Enum
        .eq('status_disponibilidade', StatusDisponibilidade.disponivel.name)
        .eq('regioes_atendimento.cidade', cidade)
        .eq('regioes_atendimento.estado', estado);

    final lista = response as List;
    return lista.map((item) => PrestadorModel.fromJson(item)).toList();
  }

  @override
  Future<void> salvar(PrestadorModel prestador) async {
    await supabase.from('prestadores').insert(prestador.toJson());
  }

  @override
  Future<void> atualizar(PrestadorModel prestador) async {
    await supabase
        .from('prestadores')
        .update(prestador.toJson())
        .eq('usuario_id', prestador.usuario.id);
  }

  @override
  Future<void> alterarDisponibilidade(
    String usuarioId,
    StatusDisponibilidade disponivel,
  ) async {
    await supabase
        .from('prestadores')
        // Salva a propriedade .name (String) no Supabase
        .update({'status_disponibilidade': disponivel.name})
        .eq('usuario_id', usuarioId);
  }
}
