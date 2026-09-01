import 'package:meu_app/core/utils/geo_utils.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/repositories/ubs_repository.dart';

class BuscarUbsProximasUsecase {
  final UbsRepository _repository;
  BuscarUbsProximasUsecase(this._repository);

  Future<List<UbsEntity>> executar({
    required double latitude,
    required double longitude,
    int limite = 10,
  }) async {
    final todas = await _repository.buscarTodasComLocalizacao();

    final comDistancia = todas
        .where((u) => u.latitude != null && u.longitude != null)
        .map((u) => u.copyWith(
              distanciaKm: calcularDistanciaKm(latitude, longitude, u.latitude!, u.longitude!),
            ))
        .toList();
 

    comDistancia.sort((a, b) => a.distanciaKm!.compareTo(b.distanciaKm!));
    return comDistancia.take(limite).toList();
  }
}