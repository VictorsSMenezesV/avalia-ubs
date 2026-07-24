import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart';

class DenunciaModel extends DenunciaEntity {
  DenunciaModel({
    required super.id,
    required super.avaliacaoId,
    required super.ubsId,
    required super.userIdDenunciante,
    required super.motivo,
    required super.criadaEm,
    super.descricao
  });


  Map<String, dynamic> toFirestoreMap() {
    return {
      'avaliacaoId': avaliacaoId,
      'ubsId': ubsId,
      'userIdDenunciante': userIdDenunciante,
      'motivo': motivo.name,
      'descricao': descricao,
      'status': 'pendente',
      'criadaEm': Timestamp.fromDate(criadaEm),
    };
  }
}
