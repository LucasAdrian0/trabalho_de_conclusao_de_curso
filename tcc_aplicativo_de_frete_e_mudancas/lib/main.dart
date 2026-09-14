import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentation/app.dart';
import 'package:flutter/material.dart';
import 'core/supabase_config.dart';
import 'core/app_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carrega as variáveis do arquivo .env da raiz do projeto
  await dotenv.load(fileName: "dotenv.env");
  // Inicializa o Supabase com validação da URI
  await SupabaseConfig.inicializar();
  runApp(MyApp(useCases: AppRepositories(Supabase.instance.client).useCases));
}
