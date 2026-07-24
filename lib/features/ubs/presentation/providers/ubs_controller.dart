// Arquivo: lib/providers/ubs_service.dart
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:meu_app/features/auth/domain/usecases/logout_usecase.dart";
import "package:meu_app/features/auth/domain/usecases/reset_password_usecase.dart";
import "package:meu_app/features/ubs/domain/usecases/cadastrar_ubs_usecase.dart";
import "package:meu_app/features/ubs/domain/usecases/ubs_usecase.dart";
import "../../domain/entites/ubs_entity.dart";

class UbsController with ChangeNotifier {
  final BuscarUbsUsecase _buscarUbsUsecase;
  final CadastrarUbsUsecase _cadastrarUbsUsecase;

  UbsController(this._buscarUbsUsecase, this._cadastrarUbsUsecase, LogoutUsecase read);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Stream<List<UbsEntity>> buscarUbs({String searchTerm = ''}) {
    return _buscarUbsUsecase.executar(searchTerm: searchTerm);
  }

  Future<String?> cadastrarUbs(UbsEntity ubs) async {
    _isLoading = true;
    notifyListeners();

    final erro = await _cadastrarUbsUsecase.executar(ubs);

    _isLoading = false;
    notifyListeners();
    return erro;
  }
}
