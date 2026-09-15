import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart';

String _uuidV4() {
  final bytes = List<int>.generate(16, (_) => Random.secure().nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-'
      '${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-'
      '${hex.substring(20)}';
}

void main() {
  late SupabaseClient client;

  setUpAll(() {
    dotenv.testLoad(fileInput: File('dotenv.env').readAsStringSync());

    final url = dotenv.env['SUPABASE_URL'];
    final secretKey = dotenv.env['SUPABASE_SECRET_KEY'];
    if (url == null || secretKey == null) {
      fail(
        'SUPABASE_URL ou SUPABASE_SECRET_KEY não foi encontrada no dotenv.env.',
      );
    }

    client = SupabaseClient(url, secretKey);
  });

  test('CRUD completo na tabela enderecos', () async {
    final usuarioId = _uuidV4();
    final enderecoId = _uuidV4();
    final email = 'crud-$usuarioId@teste.local';

    try {
      // Registro auxiliar necessário por causa da FK enderecos.usuario_id.
      await client.from('usuarios').insert({
        'id': usuarioId,
        'tipo': 'cliente',
        'nome': 'Usuário do teste CRUD',
        'email': email,
        'senha_hash': 'somente-teste-nao-utilizavel',
      });

      // CREATE
      await client.from('enderecos').insert({
        'id': enderecoId,
        'usuario_id': usuarioId,
        'tipo': 'residencial',
        'logradouro': 'Rua do Teste CRUD',
        'numero': '100',
        'bairro': 'Centro',
        'cidade': 'Ourinhos',
        'estado': 'SP',
        'cep': '19900-000',
      });

      // READ
      final criado = await client
          .from('enderecos')
          .select()
          .eq('id', enderecoId)
          .single();
      expect(criado['logradouro'], 'Rua do Teste CRUD');
      expect(criado['bairro'], 'Centro');

      // UPDATE
      await client
          .from('enderecos')
          .update({'bairro': 'Jardim Paulista'})
          .eq('id', enderecoId);
      final atualizado = await client
          .from('enderecos')
          .select()
          .eq('id', enderecoId)
          .single();
      expect(atualizado['bairro'], 'Jardim Paulista');

      // DELETE
      await client.from('enderecos').delete().eq('id', enderecoId);
      final removido = await client
          .from('enderecos')
          .select('id')
          .eq('id', enderecoId)
          .maybeSingle();
      expect(removido, isNull);
    } finally {
      // Limpeza idempotente: evita deixar resíduos se uma asserção falhar.
      await client.from('enderecos').delete().eq('id', enderecoId);
      await client.from('usuarios').delete().eq('id', usuarioId);
    }
  });
}
