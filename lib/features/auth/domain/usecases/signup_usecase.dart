import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase {
  final AuthRepository _repository;
  SignupUsecase(this._repository);

  Future<String?> executar({
    required String email,
    required String senha,
    required String nome,
  }) {
    if (nome.trim().isEmpty) return Future.value("Informe seu nome.");
    if (senha.length < 6) return Future.value("A senha precisa ter ao menos 6 caracteres.");
    return _repository.signUp(email: email.trim(), senha: senha, nome: nome.trim());
  }
}