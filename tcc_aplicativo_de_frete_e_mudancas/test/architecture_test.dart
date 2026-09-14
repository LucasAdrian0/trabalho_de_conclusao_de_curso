import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Dependências das camadas apontam para dentro', () {
    final regras = {
      'domain': ['data', 'application', 'presentation', 'core'],
      'application': ['data', 'presentation', 'core'],
      'presentation': ['data', 'core'],
    };
    final lib = Directory('lib').absolute.uri;
    for (final regra in regras.entries) {
      for (final file
          in Directory('lib/${regra.key}')
              .listSync(recursive: true)
              .whereType<File>()
              .where((f) => f.path.endsWith('.dart'))) {
        final conteudo = file.readAsStringSync();
        final diretivas = RegExp(
          r'''(?:import|export|part)\s+['"]([^'"]+)['"]''',
        ).allMatches(conteudo);
        for (final diretiva in diretivas) {
          final caminho = diretiva.group(1)!;
          final uri = caminho.startsWith('package:tcc_frete_urbano/')
              ? lib.resolve(
                  caminho.replaceFirst('package:tcc_frete_urbano/', ''),
                )
              : file.absolute.uri.resolve(caminho);
          for (final proibida in regra.value) {
            expect(
              uri.toString().startsWith(lib.resolve('$proibida/').toString()),
              isFalse,
              reason: '${file.path} depende de $caminho',
            );
          }
          if (regra.key != 'presentation') {
            expect(
              caminho.startsWith('package:flutter'),
              isFalse,
              reason: file.path,
            );
          }
          expect(caminho.contains('supabase'), isFalse, reason: file.path);
          if (regra.key == 'presentation') {
            expect(
              uri.toString().startsWith(
                lib.resolve('domain/repositories/').toString(),
              ),
              isFalse,
              reason: file.path,
            );
          }
        }
        if (regra.key == 'domain') {
          expect(
            conteudo.contains('databaseValue'),
            isFalse,
            reason: file.path,
          );
        }
      }
    }
  });

  test('Repositórios concretos não importam SDK de infraestrutura', () {
    for (final file in Directory(
      'lib/data/repositories',
    ).listSync().whereType<File>()) {
      expect(
        file.readAsStringSync().contains('package:supabase'),
        isFalse,
        reason: file.path,
      );
    }
  });
}
