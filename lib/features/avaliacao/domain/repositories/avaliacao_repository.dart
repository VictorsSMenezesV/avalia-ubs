import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';

abstract class AvaliacaoRepository {
  Stream<List<AvaliacaoEntity>> streamAvaliacoesAprovadasPorUbs(String ubsId);
  Stream<List<AvaliacaoEntity>> streamMinhasAvaliacoes(String userId);
  Future<String?> criarAvaliacao(AvaliacaoEntity avaliacao);
  Future<String?> editarAvaliacao(AvaliacaoEntity avaliacao);
  Future<String?> excluirAvaliacao(String avaliacaoId);
}
