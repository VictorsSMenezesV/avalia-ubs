import 'package:meu_app/features/ubs/domain/repositories/favorito_repository.dart';

class ObservarIsFavoritoUsecase {
  final FavoritoRepository _repository;
  ObservarIsFavoritoUsecase(this._repository);

  Stream<bool> executar({required String userId, required String ubsId}) {
    return _repository.streamIsFavorito(userId, ubsId);
  }
}