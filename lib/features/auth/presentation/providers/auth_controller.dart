// Arquivo: lib/auth/providers/auth_provider.dart

import "dart:async";


import "package:flutter/material.dart";
import "package:meu_app/features/auth/domain/entitites/user_entity.dart";
import "package:meu_app/features/auth/domain/usecases/login_usecase.dart";
import "package:meu_app/features/auth/domain/usecases/logout_usecase.dart";
import "package:meu_app/features/auth/domain/usecases/observar_usuario_logado_usecase.dart";
import "package:meu_app/features/auth/domain/usecases/reset_password_usecase.dart";
import "package:meu_app/features/auth/domain/usecases/signup_usecase.dart";

class AuthController with ChangeNotifier {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final LogoutUsecase _logoutUsecase;
  final ResetPasswordUsecase _resetPasswordUsecase;
  final ObservarUsuarioLogadoUsecase _observarUsuarioLogadoUsecase;

  AuthController(
    this._loginUsecase,
    this._signupUsecase,
    this._logoutUsecase,
    this._resetPasswordUsecase,
    this._observarUsuarioLogadoUsecase,
  ) {
    _subscription = _observarUsuarioLogadoUsecase.executar().listen(
      _aoMudarUsuario,
    );
  }

  late final StreamSubscription<UserEntity?> _subscription;

  UserEntity? _currentUser;
  bool _isVisitor = false;
  bool _isLoading = true;

  UserEntity? get currentUser => _currentUser;
  bool get isVisitor => _isVisitor;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isLoggedUser => _currentUser != null && !_isVisitor;

  void _aoMudarUsuario(UserEntity? user) {
    _currentUser = user;
    if (user != null) _isVisitor = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> login({required String email, required String senha}) {
    return _loginUsecase.executar(email: email, senha: senha);
  }

  Future<String?> signup({
    required String email,
    required String senha,
    required String nome,
  }) {
    return _signupUsecase.executar(email: email, senha: senha, nome: nome);
  }

  Future<void> entrarComoVisitante() async {
    await _logoutUsecase.executar(); // garante que não há sessão Firebase ativa
    _currentUser = null;
    _isVisitor = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _logoutUsecase.executar();
    _isVisitor = false;
    // _currentUser vira null pelo próprio listener de authStateChanges
  }

  Future<String?> sendPasswordResetEmail(String email) {
    return _resetPasswordUsecase.executar(email);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
