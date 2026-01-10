import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/account_info.dart';

class AccountProvider with ChangeNotifier {
  AccountInfo? _accountInfo;
  String? _phone;
  bool _isLoading = false;
  String? _errorMessage;

  AccountInfo? get accountInfo => _accountInfo;
  String? get phone => _phone;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future fetchAccountInfo(String login, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _accountInfo = await ApiService.getAccountInfo(login, token);
      _phone = await ApiService.getPhoneNumbers(login, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load account info';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _accountInfo = null;
    _phone = null;
    _errorMessage = null;
    notifyListeners();
  }
}
