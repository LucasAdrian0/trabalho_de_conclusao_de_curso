import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase/supabase.dart'; // Usamos o client puro para testes sem plugin nativo

void main() {
  late SupabaseClient client;

  setUpAll(() async {
    // Não inicialize TestWidgetsFlutterBinding aqui: ela bloqueia HTTP real.
    dotenv.testLoad(fileInput: File('dotenv.env').readAsStringSync());

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url == null || anonKey == null) {
      fail(
        'As variáveis SUPABASE_URL ou SUPABASE_ANON_KEY não foram encontradas no dotenv.env',
      );
    }

    // O cliente puro permite consultar o Supabase durante este teste.
    client = SupabaseClient(url, anonKey);
  });

  test('Deve conectar ao Supabase e consultar a tabela de enderecos', () async {
    final response = await client.from('enderecos').select().limit(1);

    expect(response, isA<List<dynamic>>());
  });
}
