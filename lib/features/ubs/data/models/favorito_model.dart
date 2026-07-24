import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';

class FavoritoModel extends FavoritoEntity {
  FavoritoModel({
    required super.ubsId,
    required super.ubsNome,
    required super.adicionadoEm,
  });

  factory FavoritoModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return FavoritoModel(
      ubsId: doc.id, // o ID do documento É o ubsId, por design
      ubsNome: data['ubsNome'] as String? ?? '',
      adicionadoEm: (data['adicionadoEm'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {'ubsNome': ubsNome, 'adicionadoEm': Timestamp.fromDate(adicionadoEm)};
  }
}
