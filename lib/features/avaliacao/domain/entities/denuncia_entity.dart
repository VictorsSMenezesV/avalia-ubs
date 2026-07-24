// domain/entities/denuncia_entity.dart

enum MotivoDenuncia { conteudoOfensivo, spam, informacaoFalsa, outro }

class DenunciaEntity {
  final String id;
  final String avaliacaoId;
  final String ubsId;
  final String userIdDenunciante;
  final MotivoDenuncia motivo;
  final String? descricao;
  final DateTime criadaEm;

  const DenunciaEntity({
    required this.id,
    required this.avaliacaoId,
    required this.ubsId,
    required this.userIdDenunciante,
    required this.motivo,
    this.descricao,
    required this.criadaEm,
  });
}

extension MotivoDenunciaLabel on MotivoDenuncia {
  String get label {
    switch (this) {
      case MotivoDenuncia.conteudoOfensivo:
        return 'Conteúdo ofensivo';
      case MotivoDenuncia.spam:
        return 'Spam';
      case MotivoDenuncia.informacaoFalsa:
        return 'Informação falsa';
      case MotivoDenuncia.outro:
        return 'Outro motivo';
    }
  }
}