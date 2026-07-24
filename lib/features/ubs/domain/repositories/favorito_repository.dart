import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';

abstract class FavoritoRepository {
  Stream<List<FavoritoEntity>> streamFavoritos(String userId);
  Stream<bool> streamIsFavorito(String userId, String ubsId);
  Future<String?> favoritar({required String userId, required String ubsId, required String ubsNome});
  Future<String?> desfavoritar({required String userId, required String ubsId});
}