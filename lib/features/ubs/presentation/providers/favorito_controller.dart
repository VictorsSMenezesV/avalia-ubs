// presentation/favoritos/controllers/favorito_controller.dart

import 'package:flutter/material.dart';
import 'package:meu_app/features/ubs/domain/entites/favorito_entity.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_favoritos_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/observar_is_favorito_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/toggle_favorito_usecase.dart';

class FavoritoController with ChangeNotifier {
  final BuscarFavoritosUsecase _buscarFavoritosUsecase;
  final ObservarIsFavoritoUsecase _observarIsFavoritoUsecase;
  final ToggleFavoritoUsecase _toggleFavoritoUsecase;

  FavoritoController(this._buscarFavoritosUsecase, this._observarIsFavoritoUsecase, this._toggleFavoritoUsecase);

  bool _processando = false;
  bool get processando => _processando;

  Stream<List<FavoritoEntity>> favoritos(String userId) => _buscarFavoritosUsecase.executar(userId);

  Stream<bool> isFavorito({required String userId, required String ubsId}) {
    return _observarIsFavoritoUsecase.executar(userId: userId, ubsId: ubsId);
  }

  Future<String?> toggle({
    required String userId,
    required String ubsId,
    required String ubsNome,
    required bool jaEhFavorito,
  }) async {
    _processando = true;
    notifyListeners();

    final erro = await _toggleFavoritoUsecase.executar(
      userId: userId, ubsId: ubsId, ubsNome: ubsNome, jaEhFavorito: jaEhFavorito,
    );

    _processando = false;
    notifyListeners();
    return erro;
  }
}