
enum StatusAvaliacao { aprovada, analise, rejeitada }
enum TempoEspera { ate15min, de15a30min, de30a60min, maisDe60min }
enum Lotacao { vazio, moderado, cheio, lotado }

  class AvaliacaoEntity {
  final String id;
  final String ubsId;
  final String ubsNome;
  final String userId;
  final int nota; // 1 a 5
  final String? comentario;
  final bool? teveMedicamentoDisponivel;
  final TempoEspera? tempoEspera;
  final Lotacao? lotacao;
  final StatusAvaliacao status;
  final DateTime criadaEm;

  const AvaliacaoEntity({
    required this.id,
    required this.ubsId,
    required this.ubsNome,
    required this.userId,
    required this.nota,
    this.comentario,
    this.teveMedicamentoDisponivel,
    this.tempoEspera,
    this.lotacao,
    required this.status,
    required this.criadaEm,
  });
}

extension TempoEsperaLabel on TempoEspera {
  String get label {
    switch (this) {
      case TempoEspera.ate15min:
        return 'Até 15 min';
      case TempoEspera.de15a30min:
        return '15 a 30 min';
      case TempoEspera.de30a60min:
        return '30 a 60 min';
      case TempoEspera.maisDe60min:
        return 'Mais de 1 hora';
    }
  }
}

extension LotacaoLabel on Lotacao {
  String get label {
    switch (this) {
      case Lotacao.vazio:
        return 'Vazio';
      case Lotacao.moderado:
        return 'Moderado';
      case Lotacao.cheio:
        return 'Cheio';
      case Lotacao.lotado:
        return 'Lotado';
    }
  }
}
