import 'package:meu_app/features/auth/domain/entitites/user_entity.dart';
import 'package:meu_app/features/auth/domain/repositories/auth_repository.dart';

class ObservarUsuarioLogadoUsecase {
  final AuthRepository _repository;
  ObservarUsuarioLogadoUsecase(this._repository);

  Stream<UserEntity?> executar() => _repository.authStateChanges;
}