import 'package:meu_app/features/ubs/domain/entites/endereco_entity.dart';

class UbsEntity {
  final String id;
  final String cnes;
  final DateTime criadoEm;
  final String crs;
  final String distritoAdministrativo;
  final EnderecoEntity endereco;
  final double latitude;
  final double longitude;
  final String localizacaoPrecisao;
  final String nome;
  final String sts;

  const UbsEntity({
    required this.cnes,
    required this.criadoEm,
    required this.crs,
    required this.distritoAdministrativo,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    required this.localizacaoPrecisao,
    required this.nome,
    required this.sts, required this.id,
  });
}

