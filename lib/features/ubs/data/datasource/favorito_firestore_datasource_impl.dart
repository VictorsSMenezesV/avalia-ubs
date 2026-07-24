import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/ubs/data/datasource/favorito_firestore_datasource.dart';
import 'package:meu_app/features/ubs/data/models/favorito_model.dart';

class FavoritoFirestoreDatasource implements FavoritoRemoteDatasource {
  final FirebaseFirestore _firestore;
  FavoritoFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _colecao(String userId) =>
      _firestore.collection('users').doc(userId).collection('favoritos');

  @override
  Stream<List<FavoritoModel>> streamFavoritos(String userId) {
    return _colecao(userId)
        .orderBy('adicionadoEm', descending: true)
        .snapshots()
        .map((s) => s.docs.map(FavoritoModel.fromFirestore).toList());
  }

  @override
  Stream<bool> streamIsFavorito(String userId, String ubsId) {
    // Leitura direta por ID — a mais barata possível, sem query nem índice
    return _colecao(userId).doc(ubsId).snapshots().map((doc) => doc.exists);
  }

  @override
  Future<void> favoritar({required String userId, required String ubsId, required String ubsNome}) {
    final model = FavoritoModel(ubsId: ubsId, ubsNome: ubsNome, adicionadoEm: DateTime.now());
    return _colecao(userId).doc(ubsId).set(model.toFirestoreMap());
  }

  @override
  Future<void> desfavoritar({required String userId, required String ubsId}) {
    return _colecao(userId).doc(ubsId).delete();
  }
}