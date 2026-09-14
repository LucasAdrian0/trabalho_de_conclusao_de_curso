import 'package:supabase_flutter/supabase_flutter.dart';

abstract final class SupabaseConfig {
  static Future<void> inicializar() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const key = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasAuthority ||
        !['https', 'http'].contains(uri.scheme) ||
        key.isEmpty) {
      throw StateError(
        'Configure SUPABASE_URL e SUPABASE_PUBLISHABLE_KEY com --dart-define.',
      );
    }
    await Supabase.initialize(url: url, publishableKey: key);
  }
}
