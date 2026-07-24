import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;
  LoginUsecase(this._repository);

  Future<String?> executar({required String email, required String senha}) {
    if (email.trim().isEmpty || senha.isEmpty) {
      return Future.value("Preencha e-mail e senha.");
    }
    return _repository.signIn(email: email.trim(), senha: senha);
  }
}