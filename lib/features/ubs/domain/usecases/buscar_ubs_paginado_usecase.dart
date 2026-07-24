import 'package:meu_app/features/ubs/domain/entites/pagina_ubs.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';

class BuscarUbsPaginadoUsecase {
  final UbsRepository _repository;
  BuscarUbsPaginadoUsecase(this._repository);

  Future<PaginaUbs> executar({
    required int limite,
    String? cursor,
    String searchTerm = '',
  }) {
    return _repository.buscarUbsPaginado(
      limite: limite,
      cursor: cursor,
      searchTerm: searchTerm.trim(),
    );
  }
}
