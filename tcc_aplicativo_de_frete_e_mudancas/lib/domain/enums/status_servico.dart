enum StatusServico {
  agendado,
  prestadorACaminho,
  emAndamento,
  concluido,
  canceladoPeloCliente,
  canceladoPeloPrestador;

  /// Converte a String (snake_case ou camelCase) vinda do Supabase para o Enum
  static StatusServico fromString(String? value) {
    if (value == null || value.isEmpty) return StatusServico.agendado;

    final formattedValue = value.toLowerCase().replaceAll('_', '');
    return StatusServico.values.firstWhere(
      (e) => e.name.toLowerCase() == formattedValue,
      orElse: () => StatusServico.agendado,
    );
  }
}
//aplicado no projeto para indicar o status do serviço de frete ou mudança.