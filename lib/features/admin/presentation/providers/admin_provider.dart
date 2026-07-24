// lib/admin/providers/admin_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ---------- UBS ----------

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUbs() {
    return _firestore.collection('ubs').orderBy('nome').snapshots();
  }

  // ---------- AVALIAÇÕES (agora por UBS específica) ----------

  // Recebe o ubsId e busca só as avaliações daquele documento
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAvaliacoesPorUbs(String ubsId) {
    return _firestore
        .collection('ubs')
        .doc(ubsId)
        .collection('avaliacoes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<String?> atualizarAvaliacao({
    required String ubsId,
    required String avaliacaoId,
    required String userId,
    double? nota,
    String? comentario,
    String? status,
  }) async {
    try {
      _setLoading(true);
      final dados = <String, dynamic>{
        if (nota != null) 'nota': nota,
        if (comentario != null) 'comentario': comentario,
        if (status != null) 'status': status,
      };

      final batch = _firestore.batch();
      batch.update(_firestore.doc('ubs/$ubsId/avaliacoes/$avaliacaoId'), dados);
      batch.update(_firestore.doc('users/$userId/minhasAvaliacoes/$avaliacaoId'), dados);
      await batch.commit();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> excluirAvaliacao({
    required String ubsId,
    required String avaliacaoId,
    required String userId,
  }) async {
    try {
      _setLoading(true);
      final batch = _firestore.batch();
      batch.delete(_firestore.doc('ubs/$ubsId/avaliacoes/$avaliacaoId'));
      batch.delete(_firestore.doc('users/$userId/minhasAvaliacoes/$avaliacaoId'));
      await batch.commit();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ---------- USUÁRIOS (sem alteração) ----------

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsuarios() {
    return _firestore.collection('users').orderBy('createdAt', descending: true).snapshots();
  }

  Future<String?> atualizarUsuario({
    required String userId,
    String? name,
    String? email,
  }) async {
    try {
      _setLoading(true);
      await _firestore.collection('users').doc(userId).update({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
      });
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> excluirUsuarioDocumento(String userId) async {
    try {
      _setLoading(true);
      await _firestore.collection('users').doc(userId).delete();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}