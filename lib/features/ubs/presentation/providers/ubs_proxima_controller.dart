import 'package:flutter/material.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_ubs_proxima_usecase.dart';
import 'package:meu_app/features/ubs/domain/usecases/obter_localizacao_atual_usecase.dart';

enum EstadoUbsProximas { carregando, semPermissao, semDados, sucesso }

class UbsProximasController with ChangeNotifier {
  final ObterLocalizacaoAtualUsecase _obterLocalizacaoUsecase;
  final BuscarUbsProximasUsecase _buscarUbsProximasUsecase;

  UbsProximasController(
    this._obterLocalizacaoUsecase,
    this._buscarUbsProximasUsecase,
  ) {
    carregar();
  }

  EstadoUbsProximas _estado = EstadoUbsProximas.carregando;
  List<UbsEntity> _ubsProximas = [];

  EstadoUbsProximas get estado => _estado;
  List<UbsEntity> get ubsProximas => _ubsProximas;

  Future<void> carregar() async {
    _estado = EstadoUbsProximas.carregando;
    notifyListeners();

    final (resultado: resultado, localizacao: localizacao) =
        await _obterLocalizacaoUsecase.executar();

    if (resultado != ResultadoLocalizacao.sucesso || localizacao == null) {
      _estado = EstadoUbsProximas.semPermissao;
      notifyListeners();
      return;
    }

    try {
      _ubsProximas = await _buscarUbsProximasUsecase.executar(
        latitude: localizacao.latitude,
        longitude: localizacao.longitude,
      );
      _estado = _ubsProximas.isEmpty
          ? EstadoUbsProximas.semDados
          : EstadoUbsProximas.sucesso;
    } catch (e) {
      debugPrint("Erro ao buscar UBS próximas: $e");
      _estado = EstadoUbsProximas.semDados;
    }
    notifyListeners();
  }
}
