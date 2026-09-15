import 'package:flutter_test/flutter_test.dart';
import 'package:tcc_frete_urbano/data/mappers/database_enums.dart';
import 'package:tcc_frete_urbano/data/models/avaliacao_model.dart';
import 'package:tcc_frete_urbano/data/models/historico_status_model.dart';
import 'package:tcc_frete_urbano/data/models/orcamento_model.dart';
import 'package:tcc_frete_urbano/data/models/pagamento_model.dart';
import 'package:tcc_frete_urbano/data/models/solicitacao_model.dart';
import 'package:tcc_frete_urbano/data/models/usuario_model.dart';
import 'package:tcc_frete_urbano/data/models/veiculo_model.dart';
import 'package:tcc_frete_urbano/domain/enums/status_pagamento.dart';
import 'package:tcc_frete_urbano/domain/enums/status_solicitacao.dart';
import 'package:tcc_frete_urbano/domain/enums/tipo_veiculo.dart';

void main() {
  const instante = '2026-09-13T12:00:00Z';

  test('usuário usa as colunas novas e nunca serializa senha', () {
    final model = UsuarioModel.fromJson({
      'id': 'u',
      'tipo': 'cliente',
      'nome': 'Ana',
      'email': 'ana@example.com',
      'foto_perfil_url': 'foto',
      'criado_em': instante,
      'atualizado_em': instante,
    });
    expect(model.fotoPerfilUrl, 'foto');
    expect(model.toJson(), contains('criado_em'));
    expect(model.toJson(), isNot(contains('senha_hash')));
  });

  test('veículo lê o enum, dimensões planas e valor por km', () {
    final model = VeiculoModel.fromJson({
      'id': 'v',
      'prestador_id': 'p',
      'tipo_veiculo': 'caminhao_3_4',
      'comprimento_m': 4,
      'largura_m': 2,
      'altura_m': 3,
      'valor_por_km': 5,
      'status': 'em_manutencao',
      'criado_em': instante,
    });
    expect(model.tipo, TipoVeiculo.caminhao34);
    expect(model.volumeM3, 24);
    expect(model.toJson()['valor_por_km'], 5);
  });

  test('solicitação preserva relacionamentos, itens e GeoJSON', () {
    final endereco = {
      'id': 'e',
      'usuario_id': 'c',
      'tipo': 'origem',
      'logradouro': 'Rua A',
      'cidade': 'Ourinhos',
      'estado': 'SP',
      'criado_em': instante,
    };
    final model = SolicitacaoModel.fromJson({
      'id': 's',
      'cliente_id': 'c',
      'endereco_origem': endereco,
      'endereco_destino': {...endereco, 'id': 'd', 'tipo': 'destino'},
      'data_desejada': '2026-10-01',
      'tipo_servico': 'frete',
      'rota_geojson': {'type': 'LineString', 'coordinates': []},
      'status': 'aguardando_prestador',
      'criado_em': instante,
      'atualizado_em': instante,
      'itens': [
        {
          'id': 'i',
          'solicitacao_id': 's',
          'descricao': 'Caixa',
          'quantidade': 1,
        },
      ],
    });
    expect(model.status, StatusSolicitacao.aguardandoPrestador);
    expect(model.toJson()['tipo_servico'], 'frete');
    expect(model.itens.single.descricao, 'Caixa');
  });

  test('orçamento usa os novos campos de ajudantes e total', () {
    final model = OrcamentoModel.fromJson({
      'id': 'o',
      'solicitacao_id': 's',
      'prestador_id': 'p',
      'veiculo_id': 'v',
      'ajudantes_id': 'a',
      'quantidade_ajudantes_cotada': 1,
      'valor_transporte': 100,
      'valor_ajudantes': 50,
      'valor_total': 150,
      'status': 'pendente',
      'criado_em': instante,
    });
    expect(model.toJson()['valor_total'], 150);
    expect(model.toJson()['quantidade_ajudantes_cotada'], 1);
  });

  test('pagamento converte reembolsado e mantém a transação externa', () {
    final model = PagamentoModel.fromJson({
      'id': 'p',
      'servico_id': 's',
      'metodo': 'cartao_credito',
      'valor': 100,
      'status': 'reembolsado',
      'gateway_transacao_id': 'externo',
      'criado_em': instante,
      'atualizado_em': instante,
    });
    expect(model.status, StatusPagamento.estornado);
    expect(model.gatewayTransacaoId, 'externo');
  });

  test('histórico aceita vínculo com solicitação ou serviço', () {
    final model = HistoricoStatusModel.fromJson({
      'id': 'h',
      'solicitacao_id': 's',
      'servico_id': null,
      'status_anterior': null,
      'status_novo': 'criada',
      'alterado_por': null,
      'alterado_em': instante,
    });
    expect(model.solicitacaoId, 's');
    expect(model.statusAnterior, isNull);
  });

  test('nota permanece inteira para SMALLINT', () {
    final model = AvaliacaoModel(
      id: 'a',
      servicoId: 's',
      clienteId: 'c',
      prestadorId: 'p',
      nota: 5,
      criadoEm: DateTime.utc(2026),
    );
    expect(model.toJson()['nota'], isA<int>());
  });

  test('mapper rejeita valores fora do enum SQL', () {
    expect(
      () => StatusSolicitacaoMapper.fromDatabase('desconhecido'),
      throwsFormatException,
    );
  });
}
