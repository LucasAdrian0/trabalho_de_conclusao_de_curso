import '../../domain/enums/metodo_pagamento.dart';
import '../../domain/enums/status_disponibilidade.dart';
import '../../domain/enums/status_orcamento.dart';
import '../../domain/enums/status_pagamento.dart';
import '../../domain/enums/status_servico.dart';
import '../../domain/enums/status_solicitacao.dart';
import '../../domain/enums/status_veiculo.dart';
import '../../domain/enums/tipo_endereco.dart';
import '../../domain/enums/tipo_notificacao.dart';
import '../../domain/enums/tipo_servico_solicitado.dart';
import '../../domain/enums/tipo_usuario.dart';
import '../../domain/enums/tipo_veiculo.dart';

extension MetodoPagamentoMapper on MetodoPagamento {
  static const _values = {
    MetodoPagamento.pix: 'pix',
    MetodoPagamento.cartaoCredito: 'cartao_credito',
    MetodoPagamento.cartaoDebito: 'cartao_debito',
  };
  String get databaseValue => _values[this]!;
  static MetodoPagamento fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para MetodoPagamento: $value',
        ),
      )
      .key;
}

extension StatusDisponibilidadeMapper on StatusDisponibilidade {
  static const _values = {
    StatusDisponibilidade.disponivel: 'disponivel',
    StatusDisponibilidade.indisponivel: 'indisponivel',
  };
  String get databaseValue => _values[this]!;
  static StatusDisponibilidade fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para StatusDisponibilidade: $value',
        ),
      )
      .key;
}

extension StatusOrcamentoMapper on StatusOrcamento {
  static const _values = {
    StatusOrcamento.pendente: 'pendente',
    StatusOrcamento.aceito: 'aceito',
    StatusOrcamento.recusado: 'recusado',
    StatusOrcamento.expirado: 'expirado',
  };
  String get databaseValue => _values[this]!;
  static StatusOrcamento fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para StatusOrcamento: $value',
        ),
      )
      .key;
}

extension StatusPagamentoMapper on StatusPagamento {
  static const _values = {
    StatusPagamento.pendente: 'pendente',
    StatusPagamento.aprovado: 'aprovado',
    StatusPagamento.recusado: 'recusado',
    StatusPagamento.cancelado: 'cancelado',
    StatusPagamento.estornado: 'reembolsado',
  };
  String get databaseValue => _values[this]!;
  static StatusPagamento fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para StatusPagamento: $value',
        ),
      )
      .key;
}

extension StatusServicoMapper on StatusServico {
  static const _values = {
    StatusServico.agendado: 'agendado',
    StatusServico.prestadorACaminho: 'prestador_a_caminho',
    StatusServico.emAndamento: 'em_andamento',
    StatusServico.concluido: 'concluido',
    StatusServico.canceladoPeloPrestador: 'cancelado_pelo_prestador',
    StatusServico.canceladoPeloCliente: 'cancelado_pelo_cliente',
  };
  String get databaseValue => _values[this]!;
  static StatusServico fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () =>
            throw FormatException('Valor inválido para StatusServico: $value'),
      )
      .key;
}

extension StatusSolicitacaoMapper on StatusSolicitacao {
  static const _values = {
    StatusSolicitacao.criado: 'criada',
    StatusSolicitacao.aguardandoPrestador: 'aguardando_prestador',
    StatusSolicitacao.prestadorSelecionado: 'prestador_selecionado',
    StatusSolicitacao.cancelada: 'cancelada_pelo_cliente',
    StatusSolicitacao.expirada: 'expirada',
  };
  String get databaseValue => _values[this]!;
  static StatusSolicitacao fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para StatusSolicitacao: $value',
        ),
      )
      .key;
}

extension StatusVeiculoMapper on StatusVeiculo {
  static const _values = {
    StatusVeiculo.ativo: 'ativo',
    StatusVeiculo.inativo: 'inativo',
    StatusVeiculo.emManutencao: 'em_manutencao',
  };
  String get databaseValue => _values[this]!;
  static StatusVeiculo fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () =>
            throw FormatException('Valor inválido para StatusVeiculo: $value'),
      )
      .key;
}

extension TipoEnderecoMapper on TipoEndereco {
  static const _values = {
    TipoEndereco.origem: 'origem',
    TipoEndereco.destino: 'destino',
    TipoEndereco.cadastro: 'cadastro',
  };
  String get databaseValue => _values[this]!;
  static TipoEndereco fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () =>
            throw FormatException('Valor inválido para TipoEndereco: $value'),
      )
      .key;
}

extension TipoNotificacaoMapper on TipoNotificacao {
  static const _values = {
    TipoNotificacao.novaSolicitacao: 'nova_solicitacao',
    TipoNotificacao.orcamentoRecebido: 'orcamento_recebido',
    TipoNotificacao.orcamentoAceito: 'orcamento_aceito',
    TipoNotificacao.statusServico: 'status_servico',
    TipoNotificacao.pagamento: 'pagamento',
    TipoNotificacao.avaliacao: 'avaliacao',
    TipoNotificacao.sistema: 'sistema',
  };
  String get databaseValue => _values[this]!;
  static TipoNotificacao fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para TipoNotificacao: $value',
        ),
      )
      .key;
}

extension TipoServicoSolicitadoMapper on TipoServicoSolicitado {
  static const _values = {
    TipoServicoSolicitado.mudancaResidencial: 'mudanca_residencial',
    TipoServicoSolicitado.mudancaComercial: 'mudanca_comercial',
    TipoServicoSolicitado.fretePequeno: 'frete_pequeno',
    TipoServicoSolicitado.outros: 'outros',
  };
  String get databaseValue => _values[this]!;
  static TipoServicoSolicitado fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () => throw FormatException(
          'Valor inválido para TipoServicoSolicitado: $value',
        ),
      )
      .key;
}

extension TipoUsuarioMapper on TipoUsuario {
  static const _values = {
    TipoUsuario.cliente: 'cliente',
    TipoUsuario.prestador: 'prestador',
  };
  String get databaseValue => _values[this]!;
  static TipoUsuario fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () =>
            throw FormatException('Valor inválido para TipoUsuario: $value'),
      )
      .key;
}

extension TipoVeiculoMapper on TipoVeiculo {
  static const _values = {
    TipoVeiculo.carro: 'carro',
    TipoVeiculo.moto: 'moto',
    TipoVeiculo.caminhonete: 'caminhonete',
    TipoVeiculo.caminhao: 'caminhao',
    TipoVeiculo.outros: 'outros',
  };
  String get databaseValue => _values[this]!;
  static TipoVeiculo fromDatabase(String? value) => _values.entries
      .firstWhere(
        (entry) => entry.value == value || entry.key.name == value,
        orElse: () =>
            throw FormatException('Valor inválido para TipoVeiculo: $value'),
      )
      .key;
}
