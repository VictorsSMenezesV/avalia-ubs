import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository _repository;
  LogoutUsecase(this._repository);

  Future<void> executar() => _repository.signOut();
}