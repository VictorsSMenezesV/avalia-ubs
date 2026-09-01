import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meu_app/features/ubs/data/datasource/localizacao_datasource.dart';

enum ResultadoLocalizacao {
  sucesso,
  servicoDesabilitado,
  permissaoNegada,
  tempoEsgotado,
  erroDesconhecido,
}

class LocalizacaoAtual {
  final double latitude;
  final double longitude;
  const LocalizacaoAtual({required this.latitude, required this.longitude});
}

class ObterLocalizacaoAtualUsecase {
  final LocalizacaoDatasource _datasource;
  ObterLocalizacaoAtualUsecase(this._datasource);

  Future<({ResultadoLocalizacao resultado, LocalizacaoAtual? localizacao})> executar() async {
    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      return (resultado: ResultadoLocalizacao.servicoDesabilitado, localizacao: null);
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied || permissao == LocationPermission.deniedForever) {
      return (resultado: ResultadoLocalizacao.permissaoNegada, localizacao: null);
    }

    try {
      final posicao = await _datasource.obterPosicaoAtual(); 
      return (
        resultado: ResultadoLocalizacao.sucesso,
        localizacao: LocalizacaoAtual(latitude: posicao.latitude, longitude: posicao.longitude),
      );
    } on TimeoutException {
      final ultimaConhecida = await Geolocator.getLastKnownPosition();
      if (ultimaConhecida != null) {
        return (
          resultado: ResultadoLocalizacao.sucesso,
          localizacao: LocalizacaoAtual(latitude: ultimaConhecida.latitude, longitude: ultimaConhecida.longitude),
        );
      }
      return (resultado: ResultadoLocalizacao.tempoEsgotado, localizacao: null);
    } catch (e) {
      debugPrint("Erro inesperado ao obter localização: $e");
      return (resultado: ResultadoLocalizacao.erroDesconhecido, localizacao: null);
    }
  }
}