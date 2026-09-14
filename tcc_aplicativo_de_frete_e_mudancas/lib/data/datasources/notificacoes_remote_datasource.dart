import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notificacoes_model.dart';

abstract class NotificacoesRemoteDataSource {
  Future<List<NotificacoesModel>> listarPorUsuarioId(String usuarioId);
  Future<void> marcarComoLida(String notificacaoId);
}

class NotificacoesRemoteDataSourceImpl implements NotificacoesRemoteDataSource {
  final SupabaseClient supabase;

  NotificacoesRemoteDataSourceImpl({required this.supabase});

  @override
  Future<List<NotificacoesModel>> listarPorUsuarioId(String usuarioId) async {
    final response = await supabase
        .from('notificacoes')
        .select()
        .eq('usuario_id', usuarioId)
        .order('created_at', ascending: false);

    final lista = response as List;
    return lista
        .map<NotificacoesModel>(
          (e) => NotificacoesModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> marcarComoLida(String notificacaoId) async {
    await supabase
        .from('notificacoes')
        .update({'lida': true, 'lida_em': DateTime.now().toIso8601String()})
        .eq('id', notificacaoId);
  }
}
