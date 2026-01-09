import 'package:flutter/foundation.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

enum LoginState { initial, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  LoginState _state = LoginState.initial;
  LoginState get state => _state;

  String _email = '';
  String get email => _email;

  String _password = '';
  String get password => _password;

  bool _rememberMe = false;
  bool get rememberMe => _rememberMe;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _user;
  User? get user => _user;

  String? get emailError {
    if (_email.isEmpty) return null;
    if (!_email.contains('@') || !_email.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? get passwordError {
    if (_password.isEmpty) return null;
    if (_password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  bool get isFormValid {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
        emailError == null &&
        passwordError == null;
  }

  void setEmail(String value) {
    _email = value;
    _clearError();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _clearError();
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
    }
  }

  Future<bool> login() async {
    if (!isFormValid) {
      _errorMessage = 'Please fill in all fields correctly';
      notifyListeners();
      return false;
    }

    _state = LoginState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.login(
      email: _email,
      password: _password,
      rememberMe: _rememberMe,
    );

    if (result.failure != null) {
      _state = LoginState.error;
      _errorMessage = result.failure!.message;
      notifyListeners();
      return false;
    }

    _user = result.user;
    _state = LoginState.success;
    notifyListeners();
    return true;
  }

  void reset() {
    _state = LoginState.initial;
    _email = '';
    _password = '';
    _rememberMe = false;
    _obscurePassword = true;
    _errorMessage = null;
    _user = null;
    notifyListeners();
  }
}
