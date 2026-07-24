import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';

class AvaliacaoModel extends AvaliacaoEntity {
  AvaliacaoModel({
    required super.id,
    required super.ubsId,
    required super.ubsNome,
    required super.userId,
    required super.nota,
    required super.status,
    required super.criadaEm,
    super.comentario,
    super.teveMedicamentoDisponivel,
    super.tempoEspera,
    super.lotacao,
  });

  factory AvaliacaoModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return AvaliacaoModel(
      id: doc.id,
      ubsId: data['ubsId'] as String? ?? '',
      ubsNome: data['ubsNome'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      nota: (data['nota'] as num?)?.toInt() ?? 0,
      comentario: data['comentario'] as String?,
      teveMedicamentoDisponivel: data['teveMedicamentoDisponivel'] as bool?,
      tempoEspera: _tempoEsperaFromString(data['tempoEspera'] as String?),
      lotacao: _lotacaoFromString(data['lotacao'] as String?),
      status: _statusFromString(data['status'] as String?),
      criadaEm: (data['criadaEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'ubsId': ubsId,
      'ubsNome': ubsNome,
      'userId': userId,
      'nota': nota,
      'comentario': comentario,
      'teveMedicamentoDisponivel': teveMedicamentoDisponivel,
      'tempoEspera': tempoEspera?.name,
      'lotacao': lotacao?.name,
      'status': status.name,
      'criadaEm': Timestamp.fromDate(criadaEm),
    };
  }

  static StatusAvaliacao _statusFromString(String? valor) {
    return StatusAvaliacao.values.firstWhere(
      (s) => s.name == valor,
      orElse: () => StatusAvaliacao
          .analise, // fallback seguro: nunca assume aprovado por engano
    );
  }

  static TempoEspera? _tempoEsperaFromString(String? valor) {
    if (valor == null) return null;
    return TempoEspera.values.where((t) => t.name == valor).firstOrNull;
  }

  static Lotacao? _lotacaoFromString(String? valor) {
    if (valor == null) return null;
    return Lotacao.values.where((l) => l.name == valor).firstOrNull;
  }
}
