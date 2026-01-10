import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/login_response.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = true;
  String? _token;
  String? _login;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get login => _login;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    _isAuthenticated = await AuthService.isAuthenticated();
    if (_isAuthenticated) {
      _token = await AuthService.getStoredToken();
      _login = await AuthService.getStoredLogin();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future signIn(String login, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await AuthService.login(login, password);

      if (response.isSuccessful && response.token != null) {
        _isAuthenticated = true;
        _token = response.token;
        _login = login;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await AuthService.logout();
    _isAuthenticated = false;
    _token = null;
    _login = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
