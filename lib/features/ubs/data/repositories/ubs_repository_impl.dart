import 'package:meu_app/features/ubs/data/datasource/ubs_remote_datasource.dart';
import 'package:meu_app/features/ubs/data/models/ubs_model.dart';
import 'package:meu_app/features/ubs/domain/entites/pagina_ubs.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';

class UbsRepositoryImpl implements UbsRepository {
  final UbsFirestoreDataSource _datasource;

  UbsRepositoryImpl(this._datasource);

  @override
  Stream<List<UbsEntity>> streamUbs({String searchTerm = ''}) {
    return  [] as Stream<List<UbsEntity>>;
  }

  @override
  Future<String?> addUbs(UbsEntity ubs) async {
    try {
      final model = UbsModel(
        id: ubs.id,
        nome: ubs.nome,
        endereco: ubs.endereco,
        cnes: ubs.cnes,
        criadoEm: ubs.criadoEm,
        crs: ubs.crs,
        distritoAdministrativo: ubs.distritoAdministrativo,
        latitude: ubs.latitude,
        longitude: ubs.longitude,
        localizacaoPrecisao: ubs.localizacaoPrecisao,
        sts: ubs.sts, 
        nomeNormalizado:ubs.nome,
      );
      await _datasource.addUbs(model);
      return null;
    } catch (e) {
      return 'Erro ao cadastrar UBS: ${e.toString()}';
    }
  }

  @override
Future<PaginaUbs> buscarUbsPaginado({
  required int limite,
  String? cursor,
  String searchTerm = '',
}) async {
  final docs = await _datasource.buscarUbsPaginado(
    limite: limite,
    cursor: cursor,
    searchTerm: searchTerm,
  );

   return PaginaUbs(
    itens: docs,
    proximoCursor: docs.isNotEmpty ? docs.last.nome : null, 
    temMais: docs.length == limite,
  );
  }

  @override
Future<List<UbsEntity>> buscarTodasComLocalizacao() {
  return _datasource.buscarTodasComLocalizacao();
} 
}
