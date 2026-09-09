enum TipoEndereco {
  origem,
  destino,
  cadastro;

  static TipoEndereco fromString(String? value) {
    if (value == null || value.isEmpty) return TipoEndereco.cadastro;

    final formattedValue = value.toLowerCase().replaceAll('_', '');
    return TipoEndereco.values.firstWhere(
      (e) => e.name.toLowerCase() == formattedValue,
      orElse: () => TipoEndereco.cadastro,
    );
  }
}
//aplicado de frete e mudanças