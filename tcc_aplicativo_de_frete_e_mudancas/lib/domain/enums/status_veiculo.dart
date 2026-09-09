enum StatusVeiculo {
  ativo,
  inativo,
  emManutencao;

  /// Conversão segura vinda do Supabase para o Enum
  static StatusVeiculo fromString(String? value) {
    if (value == null || value.isEmpty) return StatusVeiculo.inativo;

    final formattedValue = value.toLowerCase().replaceAll('_', '');
    return StatusVeiculo.values.firstWhere(
      (e) => e.name.toLowerCase() == formattedValue,
      orElse: () => StatusVeiculo.inativo,
    );
  }
}

//aplicado no projeto para indicar o status do veículo de um prestador de serviço de frete ou mudança.