import 'package:tcc_frete_urbano/data/mappers/database_enums.dart';
import 'package:tcc_frete_urbano/domain/errors/falha.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcc_frete_urbano/data/models/usuario_model.dart';
import 'package:tcc_frete_urbano/data/models/veiculo_model.dart';
import 'package:tcc_frete_urbano/data/models/solicitacao_model.dart';
import 'package:tcc_frete_urbano/data/models/orcamento_model.dart';
import 'package:tcc_frete_urbano/data/models/pagamento_model.dart';
import 'package:tcc_frete_urbano/data/models/historico_status_servico_model.dart';
import 'package:tcc_frete_urbano/data/models/avaliacao_model.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_veiculo.dart';

void main() {
  const date = '2026-09-13T12:00:00Z';
  test('Criação de orçamento deixa updated_at usar o default do banco', () {
    final model = OrcamentoModel.fromJson({
      'id': 'o',
      'solicitacao_id': 's',
      'prestador_id': 'p',
      'veiculo_id': 'v',
      'valor_km_aplicado': 5,
      'valor_transporte': 100,
      'quantidade_ajudantes': 0,
      'valor_ajudantes': 0,
      'valor_total_estimado': 100,
      'status': 'pendente',
      'created_at': date,
    });
    expect(model.toJson(), isNot(contains('updated_at')));
  });
  test('Nota inteira é enviada como int para SMALLINT', () {
    final model = AvaliacaoModel(
      id: 'a',
      servicoId: 's',
      clienteId: 'c',
      prestadorId: 'p',
      nota: 5,
      createdAt: DateTime.utc(2026),
    );
    expect(model.toJson()['nota'], isA<int>());
  });
  test('Usuário lê colunas reais e nunca serializa senha', () {
    final model = UsuarioModel.fromJson({
      'id': 'u',
      'tipo': 'cliente',
      'nome': 'Ana',
      'email': 'ana@example.com',
      'email_verificado': true,
      'foto_url': 'foto',
      'created_at': date,
      'updated_at': date,
    });
    expect(model.emailVerificado, isTrue);
    expect(model.fotoUrl, 'foto');
    expect(model.toJson(), contains('created_at'));
    expect(model.toJson(), isNot(contains('senha_hash')));
    expect(model.toJson(), isNot(contains('createdAt')));
  });
  test('Veículo lê dimensões em colunas e enum PostgreSQL', () {
    final model = VeiculoModel.fromJson({
      'id': 'v',
      'prestador_id': 'p',
      'tipo': 'caminhonete',
      'largura_m': 2,
      'altura_m': 3,
      'comprimento_m': 4,
      'valor_km': 5,
      'status': 'em_manutencao',
    });
    expect(model.tipo, TipoVeiculo.caminhonete);
    expect(model.dimensoes.volumeM3, 24);
    expect(model.toJson()['status'], 'em_manutencao');
    expect(model.toJson()['largura_m'], 2);
    expect(model.toJson(), isNot(contains('dimensoes')));
  });
  test('Solicitação preserva status SQL e aceita campos opcionais nulos', () {
    final address = {
      'id': 'e',
      'tipo': 'origem',
      'logradouro': 'Rua A',
      'cidade': 'Ourinhos',
      'estado': 'SP',
    };
    final model = SolicitacaoModel.fromJson({
      'id': 's',
      'cliente_id': 'c',
      'endereco_origem': address,
      'endereco_destino': {...address, 'id': 'd', 'tipo': 'destino'},
      'data_desejada': '2026-10-01',
      'tipo_servico': 'frete_pequeno',
      'status': 'aguardando_prestador',
    });
    expect(model.status, StatusSolicitacao.aguardandoPrestador);
    expect(model.toJson()['status'], 'aguardando_prestador');
    expect(model.toJson()['endereco_origem_id'], 'e');
    expect(model.toJson()['horario_desejado'], isNull);
    expect(model.enderecoOrigem.usuarioId, isNull);
    expect(
      StatusSolicitacaoMapper.fromDatabase('prestador_selecionado'),
      StatusSolicitacao.prestadorSelecionado,
    );
    expect(
      () => StatusSolicitacaoMapper.fromDatabase('desconhecido'),
      throwsFormatException,
    );
  });
  test('Orçamento preserva todos os campos obrigatórios de precificação', () {
    final model = OrcamentoModel.fromJson({
      'id': 'o',
      'solicitacao_id': 's',
      'prestador_id': 'p',
      'veiculo_id': 'v',
      'valor_km_aplicado': 5,
      'valor_transporte': 100,
      'quantidade_ajudantes': 1,
      'valor_ajudantes': 50,
      'valor_total_estimado': 150,
      'status': 'pendente',
      'created_at': date,
      'updated_at': date,
    });
    expect(model.toJson()['solicitacao_id'], 's');
    expect(model.toJson()['veiculo_id'], 'v');
    expect(model.toJson()['valor_total_estimado'], 150);
    expect(model.toJson(), isNot(contains('frete_id')));
    expect(model.toJson(), isNot(contains('observacao')));
  });
  test('Pagamento usa método e transação do SQL e cliente do serviço', () {
    final model = PagamentoModel.fromJson({
      'id': 'p',
      'servico_id': 's',
      'servicos': {'cliente_id': 'c'},
      'valor': 100,
      'metodo': 'cartao_credito',
      'status': 'reembolsado',
      'gateway_transacao_id': 'externo',
      'created_at': date,
    });
    expect(model.clienteId, 'c');
    expect(model.status, StatusPagamento.estornado);
    expect(model.toJson()['metodo'], 'cartao_credito');
    expect(model.toJson()['status'], 'reembolsado');
    expect(model.toJson(), isNot(contains('cliente_id')));
  });
  test('Primeiro histórico aceita status anterior e autor nulos', () {
    final model = HistoricoStatusServicoModel.fromJson({
      'id': 'h',
      'servico_id': 's',
      'status_anterior': null,
      'status_novo': 'agendado',
      'alterado_por': null,
      'created_at': date,
    });
    expect(model.statusAnterior, isNull);
    expect(model.toJson(), contains('alterado_por'));
  });
  test('Avaliação rejeita nota fracionária incompatível com SMALLINT', () {
    final model = AvaliacaoModel(
      id: 'a',
      servicoId: 's',
      clienteId: 'c',
      prestadorId: 'p',
      nota: 4.5,
      createdAt: DateTime.utc(2026),
    );
    expect(model.validar, throwsA(isA<Falha>()));
  });
}
