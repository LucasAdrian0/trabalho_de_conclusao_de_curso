import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/errors/falha.dart';

Falha mapearFalha(Object erro) {
  if (erro is Falha) return erro;
  if (erro is AuthException) {
    return const Falha(
      TipoFalha.naoAutenticado,
      'Não foi possível autenticar. Verifique os dados e a confirmação do e-mail.',
    );
  }
  if (erro is PostgrestException) {
    return switch (erro.code) {
      '42501' => const Falha(
        TipoFalha.acessoNegado,
        'Operação não autorizada.',
      ),
      '23505' => const Falha(TipoFalha.conflito, 'Este registro já existe.'),
      'PGRST116' || 'P0002' => const Falha(
        TipoFalha.naoEncontrado,
        'Registro não encontrado.',
      ),
      '23503' || '23514' || 'P0001' => const Falha(
        TipoFalha.conflito,
        'A operação não é permitida no estado atual.',
      ),
      _ => const Falha(
        TipoFalha.indisponivel,
        'Não foi possível acessar os dados.',
      ),
    };
  }
  if (erro is FormatException || erro is TypeError) {
    return const Falha(
      TipoFalha.dadosInvalidos,
      'O serviço retornou dados incompatíveis.',
    );
  }
  if (erro is TimeoutException) {
    return const Falha(
      TipoFalha.indisponivel,
      'O serviço demorou para responder.',
    );
  }
  return const Falha(
    TipoFalha.inesperada,
    'Não foi possível concluir a operação.',
  );
}

Future<T> executarRepositorio<T>(Future<T> Function() operacao) async {
  try {
    return await operacao();
  } catch (erro, stack) {
    Error.throwWithStackTrace(mapearFalha(erro), stack);
  }
}

Stream<T> protegerStream<T>(Stream<T> stream) => stream.transform(
  StreamTransformer<T, T>.fromHandlers(
    handleError: (Object erro, StackTrace stack, EventSink<T> sink) {
      sink.addError(mapearFalha(erro), stack);
    },
  ),
);
