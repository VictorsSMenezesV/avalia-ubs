import 'dart:async';
import 'package:geolocator/geolocator.dart';

abstract class LocalizacaoDatasource {
  Future<Position> obterPosicaoAtual();
}

class LocalizacaoGeolocatorDatasource implements LocalizacaoDatasource {
  @override
  Future<Position> obterPosicaoAtual() {
    return Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.low,
        forceLocationManager: true,
        timeLimit: const Duration(seconds: 15),
      ),
    );
  }
}