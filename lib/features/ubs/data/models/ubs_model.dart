import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_app/core/utils/string_utils.dart';
import 'package:meu_app/features/ubs/domain/entites/endereco_entity.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';


class UbsModel extends UbsEntity {
  final String nomeNormalizado;
  const UbsModel({
    required super.cnes,
    required super.criadoEm,
    required super.crs,
    required super.distritoAdministrativo,
    required super.endereco,
    required super.latitude,
    required super.longitude,
    required super.localizacaoPrecisao,
    required super.nome,
    required super.sts, 
    required super.id, 
    required this.nomeNormalizado,
  });
  // data/models/ubs_model.dart

factory UbsModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>;
  final geoPoint = data['localizacao'] as GeoPoint?;
  final enderecoMap = data['endereco'] as Map<String, dynamic>?;

  return UbsModel(
    id: doc.id,
    nome: data['nome'] as String? ?? '',
    endereco: enderecoMap != null
        ? EnderecoEntity(
            bairro: enderecoMap['bairro'],
            cep: enderecoMap['cep'],
            completo: enderecoMap['completo'],
            logradouro: enderecoMap['logradouro'],
            numero: enderecoMap['numero'],
          )
        : const EnderecoEntity(bairro: '', cep: '', completo: '', logradouro: '', numero: ''),
    latitude: geoPoint?.latitude,
    longitude: geoPoint?.longitude,
    localizacaoPrecisao: data['localizacaoPrecisao'] as String?,
    cnes: data['cnes'] as String?,
    crs: data['crs'] as String?,
    sts: data['sts'] as String?,
    distritoAdministrativo: data['distritoAdministrativo'] as String?,
    criadoEm: (data['criadoEm'] as Timestamp?)?.toDate(), nomeNormalizado: '',
  );
}

  // Método para converter um UbsModel em um Map para salvar no Firestore
  Map<String, dynamic> toFirestore() {
     return {
      "cnes": cnes,
      "criadoEm": Timestamp.fromDate(criadoEm!),
      "crs": crs,
      "distritoAdministrativo": distritoAdministrativo,
      'nome_normalizado': normalizarBusca(nome),
      "endereco": {
        "bairro": endereco.bairro,
        "cep": endereco.cep,
        "completo": endereco.completo,
        "logradouro": endereco.logradouro,
        "numero": endereco.numero,
      },
      "localizacao": GeoPoint(latitude!, longitude!),
      "localizacaoPrecisao": localizacaoPrecisao,
      "nome": nome,
      "sts": sts,
    };
  }

  
}