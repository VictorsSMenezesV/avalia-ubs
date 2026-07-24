import 'package:meu_app/features/ubs/domain/entites/pagina_ubs.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';

abstract class UbsRepository {
  Stream<List<UbsEntity>> streamUbs({String searchTerm});
  Future<String?> addUbs(UbsEntity ubs);
   Future<PaginaUbs> buscarUbsPaginado({
    required int limite,
    String? cursor,
    String searchTerm = '',
  });
}