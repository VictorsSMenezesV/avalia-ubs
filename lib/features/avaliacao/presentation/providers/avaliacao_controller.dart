import "package:flutter/material.dart";
import "package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart";
import "package:meu_app/features/avaliacao/domain/usecases/busca_avaliacoes_por_ubs_usecase.dart";
import "package:meu_app/features/avaliacao/domain/usecases/buscar_minhas_avaliacoes_usecase.dart";
import "package:meu_app/features/avaliacao/domain/usecases/criar_avaliacao_usecase.dart";
import "package:meu_app/features/avaliacao/domain/usecases/criar_denuncia_usecase.dart";
import "package:meu_app/features/avaliacao/domain/usecases/editar_avaliacao_usecase.dart";
import "package:meu_app/features/avaliacao/domain/usecases/excluir_avalicao_usecase.dart";
import "../../domain/entities/avaliacao_entity.dart";

class AvaliacaoController with ChangeNotifier {
  final CriarAvaliacaoUsecase _criarAvaliacaoUsecase;
  final BuscarAvaliacoesAprovadasPorUbsUsecase _buscarAprovadasUsecase;
  final BuscarMinhasAvaliacoesUsecase _buscarMinhasUsecase;
  final CriarDenunciaUseCase _criarDenunciaUseCase;
  final ExcluirAvaliacaoUsecase _excluirAvaliacaoUsecase;
  final EditarAvaliacaoUsecase _editarAvaliacaoUsecase;
  AvaliacaoController(CriarAvaliacaoUsecase criarAvaliacaoUsecase, 
    this._criarAvaliacaoUsecase,
     this._buscarAprovadasUsecase,
     this._buscarMinhasUsecase,
     this._criarDenunciaUseCase,
     this._excluirAvaliacaoUsecase,
     this._editarAvaliacaoUsecase,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<AvaliacaoEntity>> avaliacoesPorUbs(String ubsId) =>
      _buscarAprovadasUsecase.executar(ubsId);
  Stream<List<AvaliacaoEntity>> minhasAvaliacoes(String userId) =>
      _buscarMinhasUsecase.executar(userId);

  Future<String?> criarAvaliacao({
    required String ubsId,
    required String ubsNome,
    required String userId,
    required int nota,
    String? comentario,
    bool? teveMedicamentoDisponivel,
    TempoEspera? tempoEspera,
    Lotacao? lotacao,
  }) async {
    _isLoading = true;
    notifyListeners();

    final erro = await _criarAvaliacaoUsecase.executar(
      ubsId: ubsId,
      ubsNome: ubsNome,
      userId: userId,
      nota: nota,
      comentario: comentario,
      teveMedicamentoDisponivel: teveMedicamentoDisponivel,
      tempoEspera: tempoEspera,
      lotacao: lotacao,
    );

    _isLoading = false;
    notifyListeners();
    return erro;
  }

  Future<String?> denunciar({
    required String avaliacaoId,
    required String ubsId,
    required String userIdDenunciante,
    required MotivoDenuncia motivo,
    String? descricao,
  }) {
    return _criarDenunciaUseCase.executar(
      avaliacaoId: avaliacaoId,
      ubsId: ubsId,
      userIdDenunciante: userIdDenunciante,
      motivo: motivo,
      descricao: descricao,
    );
  }

  Future<String?> excluirAvaliacao(String avaliacaoId) async {
    return _excluirAvaliacaoUsecase.executar(avaliacaoId);
  }

  Future<String?> editarAvaliacao({
    required String avaliacaoId,
    required String ubsId,
    required String ubsNome,
    required String userId,
    required int nota,
    required String comentario,
    required bool teveMedicamentoDisponivel,
    required TempoEspera tempoEspera,
    required Lotacao lotacao,
  }) {
    _isLoading = true;
    notifyListeners();
    final erro = _editarAvaliacaoUsecase.executar(
      avaliacaoId: avaliacaoId,
      ubsId: ubsId,
      ubsNome: ubsNome,
      userId: userId,
      nota: nota,
      comentario: comentario,
      lotacao: lotacao,
      tempoEspera: tempoEspera,
      teveMedicamentoDisponivel: teveMedicamentoDisponivel,
    );
    _isLoading = false;
    notifyListeners();
    return erro;
  }
}
