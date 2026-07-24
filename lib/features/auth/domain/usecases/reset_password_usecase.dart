import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository _repository;
  ResetPasswordUsecase(this._repository);

  Future<String?> executar(String email) {
    if (email.trim().isEmpty) return Future.value("Informe um e-mail válido.");
    return _repository.sendPasswordResetEmail(email: email.trim());
  }
}