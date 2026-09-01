import '../models/ubs_model.dart';

abstract class UbsFirestoreDataSource {
  Stream<List<UbsModel>> streamUbs({String searchTerm});
  Future<void> addUbs(UbsModel ubs);
  Future<List<UbsModel>> buscarUbsPaginado({
    required int limite,
    String? cursor,
    String searchTerm = '',
  });

  Future<List<UbsModel>> buscarTodasComLocalizacao();
}
