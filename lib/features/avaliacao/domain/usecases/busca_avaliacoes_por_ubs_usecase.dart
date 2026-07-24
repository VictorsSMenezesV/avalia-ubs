import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class BuscarAvaliacoesAprovadasPorUbsUsecase {
  final AvaliacaoRepository _repository;
  BuscarAvaliacoesAprovadasPorUbsUsecase(this._repository);

  Stream<List<AvaliacaoEntity>> executar(String ubsId) {
    return _repository.streamAvaliacoesAprovadasPorUbs(ubsId);
  }
}