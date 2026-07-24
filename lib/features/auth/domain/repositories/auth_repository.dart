import 'package:meu_app/features/auth/domain/entitites/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<String?> signUp({required String email, required String senha, required String nome});
  Future<String?> signIn({required String email, required String senha});
  Future<void> signOut();
  Future<String?> sendPasswordResetEmail({required String email});
  Future<Map<String, dynamic>?> getUserProfile();
}

