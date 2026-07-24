import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/core/utils/string_utils.dart';
import 'package:meu_app/features/ubs/data/datasource/ubs_remote_datasource.dart';
import 'package:meu_app/features/ubs/data/models/ubs_model.dart';

class UbsFirestoreDataSourceImpl implements UbsFirestoreDataSource {
  final FirebaseFirestore _firestore;
  static const _collectionPath = 'ubs';

  // Injeção de dependência: quem cria essa classe decide qual instância do
  // Firestore usar — facilita testar com um FakeFirebaseFirestore, por exemplo
  UbsFirestoreDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<UbsModel>> streamUbs({String searchTerm = ''}) {
    Query<Map<String, dynamic>> query =
        _firestore.collection(_collectionPath);

    return query.snapshots().map(
          (snapshot) => snapshot.docs.map(UbsModel.fromFirestore).toList(),
        );
    }

  @override
  Future<void> addUbs(UbsModel ubs) async {
    await _firestore.collection(_collectionPath).add(ubs.toFirestore());
  }
 @override
  Future<List<UbsModel>> buscarUbsPaginado({
    required int limite,
    String? cursor,
    String searchTerm = '',
  }) async {
    Query<Map<String, dynamic>> query =
      _firestore.collection('ubs').orderBy('nome'); // campo que existe de verdade

  if (cursor != null) {
    query = query.startAfter([cursor]); // precisa ser o valor de 'nome', não de nome_normalizado
  }

  query = query.limit(limite);

  final snapshot = await query.get();
  return snapshot.docs.map(UbsModel.fromFirestore).toList();
  
  }
}