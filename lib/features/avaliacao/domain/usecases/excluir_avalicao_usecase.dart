import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class ExcluirAvaliacaoUsecase {
  final AvaliacaoRepository _repository;
  ExcluirAvaliacaoUsecase(this._repository);

  Future<String?> executar(String avaliacaoId) => _repository.excluirAvaliacao(avaliacaoId);
}