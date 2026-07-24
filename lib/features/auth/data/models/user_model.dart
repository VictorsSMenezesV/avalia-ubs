import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:meu_app/features/auth/domain/entitites/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.name,
    super.email,
    required super.role,
    super.createdAt,
  });

  factory UserModel.fromFirebaseUser(fb.User user, {required bool isAdmin}) {
    return UserModel(
      uid: user.uid,
      email: user.email,        
      name: user.displayName,
      role: isAdmin ? UserRole.admin : UserRole.user,
    );
  }

  factory UserModel.visitante(String uid) {
    return UserModel(uid: uid, role: UserRole.guest);
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "createdAt": DateTime.now(),
    };
  }
}