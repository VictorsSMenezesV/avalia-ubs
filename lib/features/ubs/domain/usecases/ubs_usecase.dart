import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';

class BuscarUbsUsecase {
  final UbsRepository _repository;
  BuscarUbsUsecase(this._repository);

  Stream<List<UbsEntity>> executar({String searchTerm = ''}) {
    return _repository.streamUbs(searchTerm: searchTerm.trim());
  }

}