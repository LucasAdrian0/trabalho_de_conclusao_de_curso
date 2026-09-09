enum StatusSolicitacao {
  criado,
  aguardandoPrestador,
  expirada,
  cancelada;

  static StatusSolicitacao fromString(String? value) {
    if (value == null || value.isEmpty) return StatusSolicitacao.criado;
    
    final formattedValue = value.toLowerCase().replaceAll('_', '');
    return StatusSolicitacao.values.firstWhere(
      (e) => e.name.toLowerCase() == formattedValue,
      orElse: () => StatusSolicitacao.criado,
    );
  }
}

//aplicado para o status da solicitação, que pode ser "criado", "aguardandoPrestador", "expirada" ou "cancelada". O método fromString permite converter uma String (em camelCase ou snake_case) para o Enum correspondente, retornando "criado" como padrão caso a String seja nula ou vazia.