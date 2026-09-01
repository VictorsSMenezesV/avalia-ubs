import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/features/avaliacao/data/models/avaliacao_model.dart';

abstract class AvaliacaoRemoteDatasource {
  Stream<List<AvaliacaoModel>> streamAvaliacoesAprovadasPorUbs(String ubsId);
  Stream<List<AvaliacaoModel>> streamMinhasAvaliacoes(String userId);
  Future<void> criarAvaliacao(AvaliacaoModel avaliacao);
  Future<void> editarAvaliacao(AvaliacaoModel avaliacao);
  Future<void> excluirAvaliacao(String avaliacaoId);
}

class AvaliacaoFirestoreDatasource implements AvaliacaoRemoteDatasource {
  final FirebaseFirestore _firestore;
  static const _colecao = 'avaliacoes';

  AvaliacaoFirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<AvaliacaoModel>> streamAvaliacoesAprovadasPorUbs(String ubsId) {
    return _firestore
        .collection(_colecao)
        .where('ubsId', isEqualTo: ubsId)
        .where('status', isEqualTo: 'aprovada')
        .orderBy('criadaEm', descending: true)
        .snapshots()
        .map((s) => s.docs.map(AvaliacaoModel.fromFirestore).toList());
  }

  @override
  Stream<List<AvaliacaoModel>> streamMinhasAvaliacoes(String userId) {
    return _firestore
        .collection(_colecao)
        .where('userId', isEqualTo: userId)
        .orderBy('criadaEm', descending: true)
        .snapshots()
        .map((s) => s.docs.map(AvaliacaoModel.fromFirestore).toList());
  }

  @override
  Future<void> criarAvaliacao(AvaliacaoModel avaliacao) async {
    await _firestore.collection(_colecao).add(avaliacao.toFirestoreMap());
  }

  @override
Future<void> editarAvaliacao(AvaliacaoModel avaliacao) {
  return _firestore.collection(_colecao).doc(avaliacao.id).update(avaliacao.toFirestoreMap());
}

@override
Future<void> excluirAvaliacao(String avaliacaoId) {
  return _firestore.collection(_colecao).doc(avaliacaoId).delete();
}
}
