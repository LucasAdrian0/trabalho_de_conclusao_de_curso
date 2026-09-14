import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
/*
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: 'dotenv.env');

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
  });

  test('Deve conectar ao Supabase e consultar a tabela de enderecos', () async {
    final client = Supabase.instance.client;
    final response = await client.from('enderecos').select().limit(1);

    expect(response, isA<List<dynamic>>());
  });
}
*/

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // 1. Mock do SharedPreferences para evitar o MissingPluginException
    SharedPreferences.setMockInitialValues({});
    
    // 2. Carrega as variáveis de ambiente
    await dotenv.load(fileName: 'dotenv.env');

    // 3. Inicializa o Supabase desativando o armazenamento local de sessão durante os testes
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      publishableKey: dotenv.env['SUPABASE_ANON_KEY']!,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
  });

  test('Deve conectar ao Supabase e consultar a tabela de enderecos', () async {
    final client = Supabase.instance.client;
    final response = await client.from('enderecos').select().limit(1);

    expect(response, isA<List<dynamic>>());
  });
}