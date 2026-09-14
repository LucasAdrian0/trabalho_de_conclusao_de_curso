import '../../domain/entities/prestador_entity.dart';
import '../../domain/enums/status_disponibilidade.dart';
import 'ajudantes_prestador_model.dart';
import 'regiao_atendimento_model.dart';
import 'usuario_model.dart';
import 'veiculo_model.dart';

class PrestadorModel extends PrestadorEntity {
  const PrestadorModel({
    required super.usuario,
    required super.cpfCnpj,
    super.statusDisponibilidade,
    super.avaliacaoMedia,
    super.totalAvaliacoes,
    super.totalServicosConcluidos,
    super.regioesAtendimento,
    super.veiculos,
    super.servicoAjudantes,
  });

  factory PrestadorModel.fromJson(Map<String, dynamic> json) {
    return PrestadorModel(
      usuario: json['usuarios'] != null
          ? UsuarioModel.fromJson(json['usuarios'] as Map<String, dynamic>)
          : UsuarioModel.fromJson(json),
      cpfCnpj: json['cpf_cnpj'] as String? ?? '',
      // Converte String do banco para Enum (com fallback para disponivel)
      statusDisponibilidade: json['status_disponibilidade'] != null
          ? StatusDisponibilidade.values.byName(
              json['status_disponibilidade'] as String,
            )
          : StatusDisponibilidade.disponivel,
      avaliacaoMedia: (json['avaliacao_media'] as num?)?.toDouble() ?? 0.0,
      totalAvaliacoes: json['total_avaliacoes'] as int? ?? 0,
      totalServicosConcluidos: json['total_servicos_concluidos'] as int? ?? 0,
      regioesAtendimento: json['regioes_atendimento'] != null
          ? (json['regioes_atendimento'] as List)
                .map(
                  (e) => RegiaoAtendimentoModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      veiculos: json['veiculos'] != null
          ? (json['veiculos'] as List)
                .map((e) => VeiculoModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      servicoAjudantes: json['ajudantes'] != null
          ? AjudantesPrestadorModel.fromJson(
              json['ajudantes'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuario.id,
      'cpf_cnpj': cpfCnpj,
      // Converte o Enum para String utilizando .name ao salvar no Supabase
      'status_disponibilidade': statusDisponibilidade.name,
    };
  }

  PrestadorEntity toEntity() => PrestadorEntity(
    usuario: UsuarioModel.fromEntity(usuario).toEntity(),
    cpfCnpj: cpfCnpj,
    statusDisponibilidade: statusDisponibilidade,
    avaliacaoMedia: avaliacaoMedia,
    totalAvaliacoes: totalAvaliacoes,
    totalServicosConcluidos: totalServicosConcluidos,
    regioesAtendimento: regioesAtendimento
        .map((item) => RegiaoAtendimentoModel.fromEntity(item).toEntity())
        .toList(),
    veiculos: veiculos
        .map((item) => VeiculoModel.fromEntity(item).toEntity())
        .toList(),
    servicoAjudantes: servicoAjudantes == null
        ? null
        : AjudantesPrestadorModel.fromEntity(servicoAjudantes!).toEntity(),
  );

  factory PrestadorModel.fromEntity(PrestadorEntity entity) {
    return PrestadorModel(
      usuario: entity.usuario,
      cpfCnpj: entity.cpfCnpj,
      statusDisponibilidade: entity.statusDisponibilidade,
      avaliacaoMedia: entity.avaliacaoMedia,
      totalAvaliacoes: entity.totalAvaliacoes,
      totalServicosConcluidos: entity.totalServicosConcluidos,
      regioesAtendimento: entity.regioesAtendimento,
      veiculos: entity.veiculos,
      servicoAjudantes: entity.servicoAjudantes,
    );
  }
}
