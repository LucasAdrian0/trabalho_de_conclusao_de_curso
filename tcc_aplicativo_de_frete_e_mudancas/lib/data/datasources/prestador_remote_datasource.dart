import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc_frete_urbano/domain/enums/status_disponibilidade.dart';
import '../models/prestador_model.dart';
import '../models/regiao_atendimento_model.dart';
import '../models/ajudantes_prestador_model.dart';
import '../models/veiculo_model.dart';

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
          '*, usuarios(id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at), regioes_atendimento(*), veiculos(*), ajudantes:ajudantes_prestador(*)',
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
          '*, usuarios(id,tipo,nome,email,telefone,foto_url,email_verificado,ativo,ultimo_login_em,created_at,updated_at), regioes_atendimento!inner(*), veiculos(*), ajudantes:ajudantes_prestador(*)',
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
    await _persistir(prestador, criar: true);
  }

  @override
  Future<void> atualizar(PrestadorModel prestador) async {
    await _persistir(prestador, criar: false);
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

  Future<void> _persistir(
    PrestadorModel prestador, {
    required bool criar,
  }) async {
    await supabase.rpc(
      'salvar_prestador_com_relacoes',
      params: {
        'p_prestador': prestador.toJson(),
        'p_criar': criar,
        'p_regioes': prestador.regioesAtendimento
            .map((r) => RegiaoAtendimentoModel.fromEntity(r).toJson())
            .toList(),
        'p_veiculos': prestador.veiculos
            .map((v) => VeiculoModel.fromEntity(v).toJson())
            .toList(),
        'p_ajudantes': prestador.servicoAjudantes == null
            ? null
            : AjudantesPrestadorModel.fromEntity(
                prestador.servicoAjudantes!,
              ).toJson(),
      },
    );
  }
}
