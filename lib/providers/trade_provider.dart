import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/trade.dart';

class TradeProvider with ChangeNotifier {
  List _trades = [];
  bool _isLoading = false;
  String? _errorMessage;

  List get trades => _trades;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalProfit {
    return _trades.fold(0, (sum, trade) => sum + trade.profit);
  }

  Future fetchTrades(String login, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trades = await ApiService.getTrades(login, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load trades';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future refreshTrades(String login, String token) async {
    await fetchTrades(login, token);
  }

  void clear() {
    _trades = [];
    _errorMessage = null;
    notifyListeners();
  }
}
