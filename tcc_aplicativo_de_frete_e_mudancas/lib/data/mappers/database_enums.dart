import '../../domain/enums/metodo_pagamento.dart';
import '../../domain/enums/status_disponibilidade.dart';
import '../../domain/enums/status_orcamento.dart';
import '../../domain/enums/status_pagamento.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/enums/status_veiculo.dart';
import '../../domain/enums/tipo_endereco.dart';
import '../../domain/enums/tipo_notificacao.dart';
import '../../domain/enums/tipo_servico_solicitado.dart';
import '../../domain/enums/tipo_usuario.dart';
import '../../domain/enums/tipo_veiculo.dart';

T _ler<T>(String? valor, Map<T, String> valores, String tipo) => valores.entries
    .firstWhere(
      (item) => item.value == valor,
      orElse: () => throw FormatException('Valor inválido para $tipo: $valor'),
    )
    .key;

extension MetodoPagamentoMapper on MetodoPagamento {
  static const valores = {
    MetodoPagamento.pix: 'pix',
    MetodoPagamento.cartaoCredito: 'cartao_credito',
    MetodoPagamento.cartaoDebito: 'cartao_debito',
  };
  String get databaseValue => valores[this]!;
  static MetodoPagamento fromDatabase(String? v) =>
      _ler(v, valores, 'MetodoPagamento');
}

extension StatusDisponibilidadeMapper on StatusDisponibilidade {
  static const valores = {
    StatusDisponibilidade.disponivel: 'disponivel',
    StatusDisponibilidade.indisponivel: 'indisponivel',
  };
  String get databaseValue => valores[this]!;
  static StatusDisponibilidade fromDatabase(String? v) =>
      _ler(v, valores, 'StatusDisponibilidade');
}

extension StatusOrcamentoMapper on StatusOrcamento {
  static const valores = {
    StatusOrcamento.pendente: 'pendente',
    StatusOrcamento.aceito: 'aceito',
    StatusOrcamento.recusado: 'recusado',
    StatusOrcamento.expirado: 'expirado',
  };
  String get databaseValue => valores[this]!;
  static StatusOrcamento fromDatabase(String? v) =>
      _ler(v, valores, 'StatusOrcamento');
}

extension StatusPagamentoMapper on StatusPagamento {
  static const valores = {
    StatusPagamento.pendente: 'pendente',
    StatusPagamento.aprovado: 'aprovado',
    StatusPagamento.recusado: 'recusado',
    StatusPagamento.cancelado: 'cancelado',
    StatusPagamento.estornado: 'reembolsado',
  };
  String get databaseValue => valores[this]!;
  static StatusPagamento fromDatabase(String? v) =>
      _ler(v, valores, 'StatusPagamento');
}

extension StatusSolicitacaoMapper on StatusSolicitacao {
  static const valores = {
    StatusSolicitacao.criada: 'criada',
    StatusSolicitacao.aguardandoPrestador: 'aguardando_prestador',
    StatusSolicitacao.prestadorSelecionado: 'prestador_selecionado',
    StatusSolicitacao.pagamentoPendente: 'pagamento_pendente',
    StatusSolicitacao.pagamentoAprovado: 'pagamento_aprovado',
    StatusSolicitacao.agendado: 'agendado',
    StatusSolicitacao.aCaminho: 'a_caminho',
    StatusSolicitacao.emAndamento: 'em_andamento',
    StatusSolicitacao.concluido: 'concluido',
    StatusSolicitacao.avaliado: 'avaliado',
    StatusSolicitacao.canceladoCliente: 'cancelado_cliente',
    StatusSolicitacao.recusadoPrestador: 'recusado_prestador',
    StatusSolicitacao.canceladoPrestador: 'cancelado_prestador',
    StatusSolicitacao.pagamentoRecusado: 'pagamento_recusado',
  };
  String get databaseValue => valores[this]!;
  static StatusSolicitacao fromDatabase(String? v) =>
      _ler(v, valores, 'StatusSolicitacao');
}

extension StatusVeiculoMapper on StatusVeiculo {
  static const valores = {
    StatusVeiculo.ativo: 'ativo',
    StatusVeiculo.inativo: 'inativo',
    StatusVeiculo.emManutencao: 'em_manutencao',
  };
  String get databaseValue => valores[this]!;
  static StatusVeiculo fromDatabase(String? v) =>
      _ler(v, valores, 'StatusVeiculo');
}

extension TipoEnderecoMapper on TipoEndereco {
  static const valores = {
    TipoEndereco.origem: 'origem',
    TipoEndereco.destino: 'destino',
    TipoEndereco.residencial: 'residencial',
    TipoEndereco.outro: 'outro',
  };
  String get databaseValue => valores[this]!;
  static TipoEndereco fromDatabase(String? v) =>
      _ler(v, valores, 'TipoEndereco');
}

extension TipoNotificacaoMapper on TipoNotificacao {
  static const valores = {
    TipoNotificacao.statusSolicitacao: 'status_solicitacao',
    TipoNotificacao.pagamento: 'pagamento',
    TipoNotificacao.avaliacao: 'avaliacao',
    TipoNotificacao.sistema: 'sistema',
  };
  String get databaseValue => valores[this]!;
  static TipoNotificacao fromDatabase(String? v) =>
      _ler(v, valores, 'TipoNotificacao');
}

extension TipoServicoSolicitadoMapper on TipoServicoSolicitado {
  static const valores = {
    TipoServicoSolicitado.mudanca: 'mudanca',
    TipoServicoSolicitado.frete: 'frete',
  };
  String get databaseValue => valores[this]!;
  static TipoServicoSolicitado fromDatabase(String? v) =>
      _ler(v, valores, 'TipoServicoSolicitado');
}

extension TipoUsuarioMapper on TipoUsuario {
  static const valores = {
    TipoUsuario.cliente: 'cliente',
    TipoUsuario.prestador: 'prestador',
  };
  String get databaseValue => valores[this]!;
  static TipoUsuario fromDatabase(String? v) => _ler(v, valores, 'TipoUsuario');
}

extension TipoVeiculoMapper on TipoVeiculo {
  static const valores = {
    TipoVeiculo.motocicleta: 'motocicleta',
    TipoVeiculo.utilitario: 'utilitario',
    TipoVeiculo.fiorino: 'fiorino',
    TipoVeiculo.saveiro: 'saveiro',
    TipoVeiculo.strada: 'strada',
    TipoVeiculo.van: 'van',
    TipoVeiculo.caminhao34: 'caminhao_3_4',
    TipoVeiculo.vuc: 'vuc',
    TipoVeiculo.outros: 'outros',
  };
  String get databaseValue => valores[this]!;
  static TipoVeiculo fromDatabase(String? v) => _ler(v, valores, 'TipoVeiculo');
}
