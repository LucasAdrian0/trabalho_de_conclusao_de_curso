class RegiaoAtendimento {
  final String id;
  final String prestadorId;
  final String cidade;
  final String estado;
  final double raioKm;

  const RegiaoAtendimento({
    required this.id,
    required this.prestadorId,
    required this.cidade,
    required this.estado,
    required this.raioKm,
  });

  bool abrangeLocalizacao(String cidadeBusca, String estadoBusca) {
    return cidade.trim().toLowerCase() == cidadeBusca.trim().toLowerCase() &&
        estado.trim().toLowerCase() == estadoBusca.trim().toLowerCase();
  }
}