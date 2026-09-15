import '../../domain/entities/prestador_entity.dart';
import '../mappers/database_enums.dart';
import 'usuario_model.dart';

class PrestadorModel extends PrestadorEntity {
  const PrestadorModel({
    required super.usuario,
    super.cpfCnpj,
    super.regiaoAtendimento,
    super.statusDisponibilidade,
    super.avaliacaoMedia,
    super.totalAvaliacoes,
  });
  factory PrestadorModel.fromJson(Map<String, dynamic> j) => PrestadorModel(
    usuario: UsuarioModel.fromJson(
      (j['usuarios'] ?? j) as Map<String, dynamic>,
    ),
    cpfCnpj: j['cpf_cnpj'],
    regiaoAtendimento: j['regiao_atendimento'],
    statusDisponibilidade: StatusDisponibilidadeMapper.fromDatabase(
      j['status_disponibilidade'],
    ),
    avaliacaoMedia: (j['avaliacao_media'] as num?)?.toDouble() ?? 0,
    totalAvaliacoes: j['total_avaliacoes'] ?? 0,
  );
  Map<String, dynamic> toJson() => {
    'usuario_id': usuario.id,
    'cpf_cnpj': cpfCnpj,
    'regiao_atendimento': regiaoAtendimento,
    'status_disponibilidade': statusDisponibilidade.databaseValue,
  };
  PrestadorEntity toEntity() => PrestadorEntity(
    usuario: UsuarioModel.fromEntity(usuario).toEntity(),
    cpfCnpj: cpfCnpj,
    regiaoAtendimento: regiaoAtendimento,
    statusDisponibilidade: statusDisponibilidade,
    avaliacaoMedia: avaliacaoMedia,
    totalAvaliacoes: totalAvaliacoes,
  );
  factory PrestadorModel.fromEntity(PrestadorEntity e) => PrestadorModel(
    usuario: e.usuario,
    cpfCnpj: e.cpfCnpj,
    regiaoAtendimento: e.regiaoAtendimento,
    statusDisponibilidade: e.statusDisponibilidade,
    avaliacaoMedia: e.avaliacaoMedia,
    totalAvaliacoes: e.totalAvaliacoes,
  );
}
