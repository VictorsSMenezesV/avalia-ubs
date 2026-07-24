import 'package:firebase_auth/firebase_auth.dart';
import 'package:meu_app/features/auth/data/datasources/auth_firebase_datasource.dart';
import 'package:meu_app/features/auth/data/models/user_model.dart';
import 'package:meu_app/features/auth/domain/entitites/user_entity.dart';
import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
   final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _datasource.authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      final isAdmin = await _datasource.checkIfAdmin(user);
      return UserModel.fromFirebaseUser(user, isAdmin: isAdmin);
    });
  }

  @override
  Future<String?> signUp({
    required String email,
    required String senha,
    required String nome,
  }) async {
    try {
      final cred = await _datasource.signUp(email: email, senha: senha);
      final user = cred.user;
      if (user == null) return "Erro desconhecido ao criar usuário.";

      final model = UserModel.fromFirebaseUser(user, isAdmin: false);
      await _datasource.criarDocumentoUsuario(
        user.uid,
        {...model.toFirestoreMap(), "name": nome},
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Ocorreu um erro durante o cadastro: ${e.code}";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<String?> signIn({required String email, required String senha}) async {
    try {
      await _datasource.signIn(email: email, senha: senha);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Ocorreu um erro durante o login: ${e.code}";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<String?> sendPasswordResetEmail({required String email}) async {
    try {
      await _datasource.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Ocorreu um erro ao enviar o e-mail: ${e.code}";
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = _datasource.authStateChanges; // ver nota abaixo
    return null; // ajustado no usecase, que já tem o uid do usuário atual em mãos
  }
 
  
}