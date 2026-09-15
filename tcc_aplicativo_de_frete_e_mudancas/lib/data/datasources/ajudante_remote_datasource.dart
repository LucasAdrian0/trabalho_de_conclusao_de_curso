import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ajudante_model.dart';

abstract class AjudanteRemoteDataSource {
  Future<List<AjudanteModel>> listar(String prestadorId);
  Future<void> salvar(AjudanteModel ajudante);
  Future<void> excluir(String id);
}

class AjudanteRemoteDataSourceImpl implements AjudanteRemoteDataSource {
  final SupabaseClient client;
  AjudanteRemoteDataSourceImpl(this.client);
  @override
  Future<List<AjudanteModel>> listar(String id) async =>
      (await client.from('ajudantes').select().eq('prestador_id', id))
          .map(AjudanteModel.fromJson)
          .toList();
  @override
  Future<void> salvar(AjudanteModel a) async {
    await client.from('ajudantes').upsert(a.toJson());
  }

  @override
  Future<void> excluir(String id) async {
    await client.from('ajudantes').delete().eq('id', id);
  }
}
