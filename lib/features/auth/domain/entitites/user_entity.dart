enum UserRole { admin, user, guest }

class UserEntity {
  final String uid;
  final String? name;
  final String? email;
  final DateTime? createdAt;
  final UserRole role;

  const UserEntity({
    required this.uid,
    this.name,
    this.email,
    this.createdAt,
    required this.role,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isGuest => role == UserRole.guest;
  bool get isLoggedUser => role == UserRole.user || role == UserRole.admin;
}
