import 'presentation/app.dart';
import 'package:flutter/material.dart';
import 'core/supabase_config.dart';
import 'core/app_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.inicializar();
  runApp(MyApp(useCases: AppRepositories(Supabase.instance.client).useCases));
}