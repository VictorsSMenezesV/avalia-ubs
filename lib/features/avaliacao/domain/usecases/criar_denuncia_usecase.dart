import 'package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/denuncia_repository.dart';

class CriarDenunciaUseCase {
  final DenunciaRepository _repository;
  CriarDenunciaUseCase(this._repository);

  Future<String?> executar({
    required String avaliacaoId,
    required String ubsId,
    required String userIdDenunciante,
    required MotivoDenuncia motivo,
    String? descricao,
  }) {
    final denuncia = DenunciaEntity(
      id: '', 
      avaliacaoId: avaliacaoId,
      ubsId: ubsId,
      userIdDenunciante: userIdDenunciante,
      motivo: motivo,
      descricao: descricao?.trim().isEmpty == true ? null : descricao?.trim(),
      criadaEm: DateTime.now(),
    );
    return _repository.criarDenuncia(denuncia);
  }
}