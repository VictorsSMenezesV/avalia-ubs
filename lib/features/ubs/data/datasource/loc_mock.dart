import 'package:geolocator/geolocator.dart';
import 'package:meu_app/features/ubs/data/datasource/localizacao_datasource.dart';

class LocalizacaoMockDatasource implements LocalizacaoDatasource {
  final double latitude;
  final double longitude;

  const LocalizacaoMockDatasource({required this.latitude, required this.longitude});

  @override
  Future<Position> obterPosicaoAtual() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 10,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}