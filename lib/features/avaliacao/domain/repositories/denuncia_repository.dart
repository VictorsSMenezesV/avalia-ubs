import 'package:meu_app/features/avaliacao/domain/entities/denuncia_entity.dart';

abstract class DenunciaRepository {
  Future<String?> criarDenuncia(DenunciaEntity denuncia);
}