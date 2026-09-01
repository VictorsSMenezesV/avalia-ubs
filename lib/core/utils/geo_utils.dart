
import 'dart:math';

double calcularDistanciaKm(double lat1, double lon1, double lat2, double lon2) {
  const raioTerraKm = 6371;
  final dLat = _grausParaRad(lat2 - lat1);
  final dLon = _grausParaRad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_grausParaRad(lat1)) * cos(_grausParaRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return raioTerraKm * c;
}

double _grausParaRad(double graus) => graus * (pi / 180);