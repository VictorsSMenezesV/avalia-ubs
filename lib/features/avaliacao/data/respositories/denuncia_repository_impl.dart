import 'package:meu_app/features/avaliacao/data/datasources/denuncia_firestore_datasource.dart';
import 'package:meu_app/features/avaliacao/data/models/denuncia_model.dart';
import 'package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart';
import 'package:meu_app/features/avaliacao/domain/repositories/denuncia_repository.dart';

class DenunciaRepositoryImpl implements DenunciaRepository {
  final DenunciaRemoteDatasource _datasource;
  DenunciaRepositoryImpl(this._datasource);

  @override
  Future<String?> criarDenuncia(DenunciaEntity denuncia) async {
    try {
      final model = DenunciaModel(
        id: denuncia.id, avaliacaoId: denuncia.avaliacaoId, ubsId: denuncia.ubsId,
        userIdDenunciante: denuncia.userIdDenunciante, motivo: denuncia.motivo,
        descricao: denuncia.descricao, criadaEm: denuncia.criadaEm,
      );
      await _datasource.criarDenuncia(model);
      return null;
    } catch (e) {
      return "Erro ao enviar denúncia: ${e.toString()}";
    }
  }
}