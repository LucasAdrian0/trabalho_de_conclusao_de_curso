import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/enums/status_veiculo.dart';
import '../models/veiculo_model.dart';

abstract class VeiculoRemoteDataSource {
  Future<VeiculoModel?> buscarPorId(String id);
  Future<List<VeiculoModel>> listarPorPrestadorId(String prestadorId);
  Future<void> salvar(VeiculoModel veiculo);
  Future<void> atualizarStatus(String veiculoId, StatusVeiculo status);
  Future<void> deletar(String veiculoId);
}

class VeiculoRemoteDataSourceImpl implements VeiculoRemoteDataSource {
  final SupabaseClient supabase;

  VeiculoRemoteDataSourceImpl({required this.supabase});

  @override
  Future<VeiculoModel?> buscarPorId(String id) async {
    final response = await supabase
        .from('veiculos')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return VeiculoModel.fromJson(response);
  }

  @override
  Future<List<VeiculoModel>> listarPorPrestadorId(String prestadorId) async {
    final response = await supabase
        .from('veiculos')
        .select()
        .eq('prestador_id', prestadorId);

    final lista = response as List;
    return lista.map((e) => VeiculoModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> salvar(VeiculoModel veiculo) async {
    await supabase.from('veiculos').upsert(veiculo.toJson());
  }

  @override
  Future<void> atualizarStatus(String veiculoId, StatusVeiculo status) async {
    await supabase
        .from('veiculos')
        .update({'status': status.name})
        .eq('id', veiculoId);
  }

  @override
  Future<void> deletar(String veiculoId) async {
    await supabase.from('veiculos').delete().eq('id', veiculoId);
  }
}