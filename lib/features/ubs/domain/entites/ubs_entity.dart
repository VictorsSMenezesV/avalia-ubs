import 'package:meu_app/features/ubs/domain/entites/endereco_entity.dart';

class UbsEntity {
  final String id;
  final String nome;
  final EnderecoEntity endereco;
  final double? latitude;
  final double? longitude;
  final String? localizacaoPrecisao;
  final String? cnes;
  final String? crs;
  final String? sts;
  final String? distritoAdministrativo;
  final DateTime? criadoEm;
  final double? distanciaKm; 

  const UbsEntity({
    required this.id,
    required this.nome,
    required this.endereco,
    this.latitude,
    this.longitude,
    this.localizacaoPrecisao,
    this.cnes,
    this.crs,
    this.sts,
    this.distritoAdministrativo,
    this.criadoEm,
    this.distanciaKm,
  });

  UbsEntity copyWith({double? distanciaKm}) {
    return UbsEntity(
      id: id,
      nome: nome,
      endereco: endereco,
      latitude: latitude,
      longitude: longitude,
      localizacaoPrecisao: localizacaoPrecisao,
      cnes: cnes,
      crs: crs,
      sts: sts,
      distritoAdministrativo: distritoAdministrativo,
      criadoEm: criadoEm,
      distanciaKm: distanciaKm ?? this.distanciaKm,
    );
  }
}