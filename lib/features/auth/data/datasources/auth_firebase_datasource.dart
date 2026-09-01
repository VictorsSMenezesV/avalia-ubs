import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource {
  Stream<User?> get authStateChanges;
  Future<bool> checkIfAdmin(User user, {bool forceRefresh = false});
  Future<UserCredential> signUp({required String email, required String senha});
  Future<UserCredential> signIn({required String email, required String senha});
  Future<void> signOut();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> criarDocumentoUsuario(String uid, Map<String, dynamic> dados);
  Future<Map<String, dynamic>?> getUserProfile(String uid);
}

class AuthFirebaseDatasource implements AuthRemoteDatasource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDatasource({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<bool> checkIfAdmin(User user, {bool forceRefresh = false}) async {
    final idTokenResult = await user.getIdTokenResult(forceRefresh);
    return idTokenResult.claims?["admin"] == true;
  }

  @override
  Future<UserCredential> signUp({required String email, required String senha}) {
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
  }

  @override
  Future<UserCredential> signIn({required String email, required String senha}) {
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> criarDocumentoUsuario(String uid, Map<String, dynamic> dados) {
    return _firestore.collection("users").doc(uid).set(dados);
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data();
  }
}