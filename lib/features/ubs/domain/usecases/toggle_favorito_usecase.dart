import 'package:meu_app/features/ubs/domain/repositories/favorito_repository.dart';

class ToggleFavoritoUsecase {
  final FavoritoRepository _repository;
  ToggleFavoritoUsecase(this._repository);

  Future<String?> executar({
    required String userId,
    required String ubsId,
    required String ubsNome,
    required bool jaEhFavorito,
  }) {
    // Regra de negócio: decide favoritar ou desfavoritar com base no estado atual —
    // o usecase é quem decide isso, não a tela
    if (jaEhFavorito) {
      return _repository.desfavoritar(userId: userId, ubsId: ubsId);
    }
    return _repository.favoritar(userId: userId, ubsId: ubsId, ubsNome: ubsNome);
  }
}