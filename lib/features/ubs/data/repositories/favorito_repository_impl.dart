import 'package:meu_app/features/ubs/data/datasource/favorito_firestore_datasource.dart';
import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/favorito_repository.dart';

class FavoritoRepositoryImpl implements FavoritoRepository {
  final FavoritoRemoteDatasource _datasource;
  FavoritoRepositoryImpl(this._datasource);

  @override
  Stream<List<FavoritoEntity>> streamFavoritos(String userId) => _datasource.streamFavoritos(userId);

  @override
  Stream<bool> streamIsFavorito(String userId, String ubsId) => _datasource.streamIsFavorito(userId, ubsId);

  @override
  Future<String?> favoritar({required String userId, required String ubsId, required String ubsNome}) async {
    try {
      await _datasource.favoritar(userId: userId, ubsId: ubsId, ubsNome: ubsNome);
      return null;
    } catch (e) {
      return "Erro ao favoritar: ${e.toString()}";
    }
  }

  @override
  Future<String?> desfavoritar({required String userId, required String ubsId}) async {
    try {
      await _datasource.desfavoritar(userId: userId, ubsId: ubsId);
      return null;
    } catch (e) {
      return "Erro ao remover favorito: ${e.toString()}";
    }
  }
}