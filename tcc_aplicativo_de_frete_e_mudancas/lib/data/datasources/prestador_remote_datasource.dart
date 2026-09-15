import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/prestador_model.dart';
import 'usuario_remote_datasource.dart';

abstract class PrestadorRemoteDataSource {
  Future<PrestadorModel?> buscar(String usuarioId);
  Future<List<PrestadorModel>> listarDisponiveis(String regiao);
  Future<void> salvar(PrestadorModel prestador);
  Future<void> atualizarDisponibilidade(String id, String status);
}

class PrestadorRemoteDataSourceImpl implements PrestadorRemoteDataSource {
  final SupabaseClient client;
  PrestadorRemoteDataSourceImpl(this.client);
  static const selecao =
      'cpf_cnpj,regiao_atendimento,status_disponibilidade,avaliacao_media,total_avaliacoes,usuarios(${UsuarioRemoteDataSourceImpl.colunas})';
  @override
  Future<PrestadorModel?> buscar(String id) async {
    final j = await client
        .from('prestadores')
        .select(selecao)
        .eq('usuario_id', id)
        .maybeSingle();
    return j == null ? null : PrestadorModel.fromJson(j);
  }

  @override
  Future<List<PrestadorModel>> listarDisponiveis(String regiao) async {
    final j = await client
        .from('prestadores')
        .select(selecao)
        .eq('status_disponibilidade', 'disponivel')
        .ilike('regiao_atendimento', regiao);
    return j.map(PrestadorModel.fromJson).toList();
  }

  @override
  Future<void> salvar(PrestadorModel p) async {
    await client.from('prestadores').upsert(p.toJson());
  }

  @override
  Future<void> atualizarDisponibilidade(String id, String status) async {
    await client
        .from('prestadores')
        .update({'status_disponibilidade': status})
        .eq('usuario_id', id);
  }
}
