// presentation/ubs/controllers/ubs_lista_paginada_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meu_app/core/utils/string_utils.dart';
import 'package:meu_app/features/ubs/domain/entites/ubs_entity.dart';
import 'package:meu_app/features/ubs/domain/usecases/buscar_ubs_paginado_usecase.dart';

class UbsListaPaginadaController with ChangeNotifier {
  final BuscarUbsPaginadoUsecase _buscarUbsPaginadoUsecase;
  UbsListaPaginadaController(this._buscarUbsPaginadoUsecase) {
    _carregarPrimeiroLote();
  }

  static const int _tamanhoLote = 40;
  static const int _tamanhoPagina = 20;

  List<UbsEntity> _buffer = [];
  int _quantidadeExibida = 0;
  String? _proximoCursor;
  bool _temMaisLotes = true;
  bool _carregando = false;
  String _searchTerm = '';
  Timer? _debounce;

  bool get carregando => _carregando;

  List<UbsEntity> get itensExibidos {
    if (_searchTerm.isEmpty) {
      return _buffer.take(_quantidadeExibida).toList();
    }

    final termo = normalizarBusca(_searchTerm);
    return _buffer
        .where((ubs) => normalizarBusca(ubs.nome).contains(termo))
        .toList();
  }

  bool get temMaisParaCarregar =>
      _searchTerm.isEmpty &&
      (_quantidadeExibida < _buffer.length || _temMaisLotes);

  Future<void> _carregarPrimeiroLote() async {
    _carregando = true;
    notifyListeners();

    final pagina = await _buscarUbsPaginadoUsecase.executar(
      limite: _tamanhoLote,
    );

    _buffer = pagina.itens;
    _proximoCursor = pagina.proximoCursor;
    _temMaisLotes = pagina.temMais;
    _quantidadeExibida = _buffer.length.clamp(0, _tamanhoPagina);
    _carregando = false;
    notifyListeners();
  }

  Future<void> carregarProximaPagina() async {
    if (_carregando || _searchTerm.isNotEmpty) return;

    if (_quantidadeExibida < _buffer.length) {
      _quantidadeExibida = (_quantidadeExibida + _tamanhoPagina).clamp(
        0,
        _buffer.length,
      );
      notifyListeners();
      return;
    }

    if (_temMaisLotes) {
      _carregando = true;
      notifyListeners();

      try {
        final pagina = await _buscarUbsPaginadoUsecase.executar(
          limite: _tamanhoLote,
          cursor: _proximoCursor,
        );

        _buffer = [..._buffer, ...pagina.itens];
        _proximoCursor = pagina.proximoCursor;
        _temMaisLotes = pagina.temMais;
        _quantidadeExibida = (_quantidadeExibida + _tamanhoPagina).clamp(
          0,
          _buffer.length,
        );
      } catch (e, stackTrace) {
        debugPrint("Erro ao carregar próxima página de UBS: $e\n$stackTrace");
        _temMaisLotes = false; 
      } finally {
        _carregando = false;
        notifyListeners();
      }
    }
  }

  void buscarPorNome(String termo) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _searchTerm = termo;
      notifyListeners(); 
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
