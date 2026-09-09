import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_frete_urbano/data/models/notificacoes_model.dart';

abstract class NotificacaoRemoteDataSource {
  Future<List<NotificacoesModel>> listarPorUsuarioId(String usuarioId);
  Future<void> marcarComoLida(String notificacaoId);
}

class NotificacaoRemoteDataSourceImpl implements NotificacaoRemoteDataSource {
  final SupabaseClient supabase;

  NotificacaoRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<NotificacoesModel>> listarPorUsuarioId(String usuarioId) async {
    final response = await supabase
        .from('notificacoes')
        .select()
        .eq('usuario_id', usuarioId)
        .order('created_at', ascending: false);

    final lista = response as List;
    return lista.map((e) => NotificacoesModel.fromJson(e)).toList();
  }

  @override
  Future<void> marcarComoLida(String notificacaoId) async {
    await supabase.from('notificacoes').update({
      'lida': true,
      'lida_em': DateTime.now().toIso8601String(),
    }).eq('id', notificacaoId);
  }
}