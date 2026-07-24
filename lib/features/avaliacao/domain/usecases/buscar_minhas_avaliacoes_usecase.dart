import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class BuscarMinhasAvaliacoesUsecase {
 final AvaliacaoRepository _repository;
  BuscarMinhasAvaliacoesUsecase(this._repository);

  Stream<List<AvaliacaoEntity>> executar(String userId) {
    return _repository.streamMinhasAvaliacoes(userId);
  }
}