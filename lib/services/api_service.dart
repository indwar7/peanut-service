import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://peanut.ifxdb.com';
  
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  int? _login;

  void setCredentials(int login, String token) {
    _login = login;
    _token = token;
  }

  Future<Map<String, dynamic>> authenticate(int login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/IsAccountCredentialsCorrect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': login, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['result'] == true) {
          _token = data['token'];
          _login = login;
          return {'success': true, 'token': data['token']};
        }
        return {'success': false, 'message': 'Invalid credentials'};
      }
      return {'success': false, 'message': 'Server error'};
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<Map<String, dynamic>?> getAccountInformation() async {
    if (_token == null || _login == null) return null;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetAccountInformation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getLastFourNumbersPhone() async {
    if (_token == null || _login == null) return null;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetLastFourNumbersPhone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return response.body.replaceAll('"', '');
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>> getOpenTrades() async {
    if (_token == null || _login == null) return [];
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetOpenTrades'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body) as List;
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getClosedTrades({required int count, required int offset, required int from, required int to}) async {
    if (_token == null || _login == null) return [];
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetClosedTrades'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'count': count, 'offset': offset, 'from': from, 'to': to, 'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body) as List;
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getBalanceOperationsHistory() async {
    if (_token == null || _login == null) return [];
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetBalanceOperationsHistory'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body) as List;
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> getBonusStatistic() async {
    if (_token == null || _login == null) return null;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetBonusStatistic'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getDepositLink() async {
    if (_token == null || _login == null) return null;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/GetDepositLink'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'login': _login, 'token': _token}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    if (_token == null || _login == null) return false;
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/ClientCabinetBasic/UpdatePassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'oldPassword': oldPassword, 'newPassword': newPassword, 'login': _login, 'token': _token}),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _token = null;
    _login = null;
  }

  bool get isAuthenticated => _token != null && _login != null;
  String? get token => _token;
  int? get login => _login;
}