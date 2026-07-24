import 'package:meu_app/features/avaliacao/data/datasources/avaliacao_firestore_datasource.dart';
import 'package:meu_app/features/avaliacao/data/models/avaliacao_model.dart';
import 'package:meu_app/features/avaliacao/domain/entities/avaliacao_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/avaliacao_repository.dart';

class AvaliacaoRepositoryImpl implements AvaliacaoRepository {
  final AvaliacaoRemoteDatasource _datasource;
  AvaliacaoRepositoryImpl(this._datasource);

  @override
  Stream<List<AvaliacaoEntity>> streamAvaliacoesAprovadasPorUbs(String ubsId) {
    return _datasource.streamAvaliacoesAprovadasPorUbs(ubsId);
  }

  @override
  Stream<List<AvaliacaoEntity>> streamMinhasAvaliacoes(String userId) {
    return _datasource.streamMinhasAvaliacoes(userId);
  }

  @override
  Future<String?> criarAvaliacao(AvaliacaoEntity avaliacao) async {
    try {
      final model = AvaliacaoModel(
        id: avaliacao.id,
        ubsId: avaliacao.ubsId,
        ubsNome: avaliacao.ubsNome,
        userId: avaliacao.userId,
        nota: avaliacao.nota,
        comentario: avaliacao.comentario,
        teveMedicamentoDisponivel: avaliacao.teveMedicamentoDisponivel,
        tempoEspera: avaliacao.tempoEspera,
        lotacao: avaliacao.lotacao,
        status: avaliacao.status,
        criadaEm: avaliacao.criadaEm,
      );
      await _datasource.criarAvaliacao(model);
      return null;
    } catch (e) {
      return "Erro ao enviar avaliação: ${e.toString()}";
    }
  }

  @override
  Future<String?> editarAvaliacao(AvaliacaoEntity avaliacao) async {
    try {
      final model = AvaliacaoModel(
        id: avaliacao.id,
        ubsId: avaliacao.ubsId,
        ubsNome: avaliacao.ubsNome,
        userId: avaliacao.userId,
        nota: avaliacao.nota,
        comentario: avaliacao.comentario,
        teveMedicamentoDisponivel: avaliacao.teveMedicamentoDisponivel,
        tempoEspera: avaliacao.tempoEspera,
        lotacao: avaliacao.lotacao,
        status: avaliacao.status,
        criadaEm: avaliacao.criadaEm,
      );
      await _datasource.editarAvaliacao(model);
      return null;
    } catch (e) {
      return "Erro ao atualizar avaliação: ${e.toString()}";
    }
  }

  @override
  Future<String?> excluirAvaliacao(String avaliacaoId) async {
    try {
      await _datasource.excluirAvaliacao(avaliacaoId);
      return null;
    } catch (e) {
      return "Erro ao excluir avaliação: ${e.toString()}";
    }
  }
}
