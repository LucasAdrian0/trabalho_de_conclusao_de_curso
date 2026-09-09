enum TipoServicoSolicitado {
  mudancaResidencial,
  mudancaComercial,
  transporteDeVeiculo,
  transporteDeCarga,
  fretePequeno,
  transporteDeAnimais,
  outros;

  /// Converte a String do Supabase (seja camelCase ou snake_case) para o Enum
  static TipoServicoSolicitado fromString(String? value) {
    if (value == null || value.isEmpty) return TipoServicoSolicitado.outros;

    final formattedValue = value.toLowerCase().replaceAll('_', '');
    return TipoServicoSolicitado.values.firstWhere(
      (e) => e.name.toLowerCase() == formattedValue,
      orElse: () => TipoServicoSolicitado.outros,
    );
  }
}

//aplicado no projeto para indicar o tipo de serviço solicitado, que pode ser mudança residencial, mudança comercial, transporte de veículo, transporte de carga, frete pequeno, transporte de animais ou outros.
