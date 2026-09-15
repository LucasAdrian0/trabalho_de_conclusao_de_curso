import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notificacoes_model.dart';

abstract class NotificacaoRemoteDataSource {
  Future<List<NotificacoesModel>> listar(String usuarioId);
  Future<void> marcarLida(String id);
}

class NotificacaoRemoteDataSourceImpl implements NotificacaoRemoteDataSource {
  final SupabaseClient client;
  NotificacaoRemoteDataSourceImpl(this.client);
  @override
  Future<List<NotificacoesModel>> listar(String id) async =>
      (await client
              .from('notificacoes')
              .select()
              .eq('usuario_id', id)
              .order('criado_em', ascending: false))
          .map(NotificacoesModel.fromJson)
          .toList();
  @override
  Future<void> marcarLida(String id) async {
    await client.from('notificacoes').update({'lida': true}).eq('id', id);
  }
}
