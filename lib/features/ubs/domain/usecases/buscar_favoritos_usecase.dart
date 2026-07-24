import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/favorito_repository.dart';

class BuscarFavoritosUsecase {
  final FavoritoRepository _repository;
  BuscarFavoritosUsecase(this._repository);

  Stream<List<FavoritoEntity>> executar(String userId) => _repository.streamFavoritos(userId);
}