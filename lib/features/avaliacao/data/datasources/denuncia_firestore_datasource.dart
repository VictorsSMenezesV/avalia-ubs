import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/avaliacao/data/models/denuncia_model.dart';

abstract class DenunciaRemoteDatasource {
  Future<void> criarDenuncia(DenunciaModel denuncia);
}

class DenunciaFirestoreDatasource implements DenunciaRemoteDatasource {
  final FirebaseFirestore _firestore;
  DenunciaFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> criarDenuncia(DenunciaModel denuncia) {
    // ID determinístico: uma denúncia por (avaliação, usuário) — reenviar sobrescreve, não duplica
    final id = '${denuncia.avaliacaoId}_${denuncia.userIdDenunciante}';
    return _firestore.collection('denuncias').doc(id).set(denuncia.toFirestoreMap());
  }
}