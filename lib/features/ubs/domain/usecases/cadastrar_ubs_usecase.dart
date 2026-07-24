import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';

class CadastrarUbsUsecase {
  final UbsRepository _repository;
  CadastrarUbsUsecase(this._repository);

  Future<String?> executar(UbsEntity ubs) async {
    return _repository.addUbs(ubs);
  }
}