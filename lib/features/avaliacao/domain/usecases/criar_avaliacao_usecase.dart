import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class CriarAvaliacaoUsecase {
   final AvaliacaoRepository _repository;
  CriarAvaliacaoUsecase(this._repository);

  Future<String?> executar({
    required String ubsId,
    required String ubsNome,
    required String userId,
    required int nota,
    String? comentario,
    bool? teveMedicamentoDisponivel,
    TempoEspera? tempoEspera,
    Lotacao? lotacao,
  }) {
    if (nota < 1 || nota > 5) {
      return Future.value("A nota precisa estar entre 1 e 5.");
    }

    final comentarioLimpo = comentario?.trim();
    final temComentario = comentarioLimpo != null && comentarioLimpo.isNotEmpty;

    // Regra de negócio: comentário livre exige revisão humana (pode conter
    // ofensa, informação falsa, spam). Nota + seleções estruturadas (sem texto
    // livre) são consideradas seguras o suficiente pra publicação automática.
    final status = temComentario ? StatusAvaliacao.analise : StatusAvaliacao.aprovada;

    final avaliacao = AvaliacaoEntity(
      id: '', // gerado no datasource
      ubsId: ubsId,
      ubsNome: ubsNome,
      userId: userId,
      nota: nota,
      comentario: temComentario ? comentarioLimpo : null,
      teveMedicamentoDisponivel: teveMedicamentoDisponivel,
      tempoEspera: tempoEspera,
      lotacao: lotacao,
      status: status,
      criadaEm: DateTime.now(),
    );

    return _repository.criarAvaliacao(avaliacao);
  }
}