import 'package:meu_app/features/ubs/data/models/favorito_model.dart';

abstract class FavoritoRemoteDatasource {
  Stream<List<FavoritoModel>> streamFavoritos(String userId);
  Stream<bool> streamIsFavorito(String userId, String ubsId);
  Future<void> favoritar({required String userId, required String ubsId, required String ubsNome});
  Future<void> desfavoritar({required String userId, required String ubsId});
}