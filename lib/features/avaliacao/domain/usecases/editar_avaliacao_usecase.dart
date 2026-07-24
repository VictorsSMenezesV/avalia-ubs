import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class EditarAvaliacaoUsecase {
  final AvaliacaoRepository _repository;
  EditarAvaliacaoUsecase(this._repository);

  Future<String?> executar({
    required String avaliacaoId,
    required String ubsId,
    required String ubsNome,
    required String userId,
    required int nota,
    String? comentario,
    bool? teveMedicamentoDisponivel,
    TempoEspera? tempoEspera,
    Lotacao? lotacao,
  }) {
    if (nota < 1 || nota > 5) return Future.value("A nota precisa estar entre 1 e 5.");

    final comentarioLimpo = comentario?.trim();
    final temComentario = comentarioLimpo != null && comentarioLimpo.isNotEmpty;
    // Mesma regra do CriarAvaliacaoUsecase — editar não escapa da moderação
    final status = temComentario ? StatusAvaliacao.analise : StatusAvaliacao.aprovada;

    final avaliacao = AvaliacaoEntity(
      id: avaliacaoId, ubsId: ubsId, ubsNome: ubsNome, userId: userId, nota: nota,
      comentario: temComentario ? comentarioLimpo : null,
      teveMedicamentoDisponivel: teveMedicamentoDisponivel,
      tempoEspera: tempoEspera, lotacao: lotacao, status: status, criadaEm: DateTime.now(),
    );

    return _repository.editarAvaliacao(avaliacao);
  }
}