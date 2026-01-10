import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/account_info.dart';
import '../models/trade.dart';

class ApiService {
  static Future login(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          LoginRequest(login: login, password: password).toJson(),
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        return LoginResponse(
          isSuccessful: false,
          message: 'Login failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return LoginResponse(
        isSuccessful: false,
        message: 'Network error: ${e.toString()}',
      );
    }
  }

  static Future getAccountInfo(String login, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.accountInfoEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Login': login, 'Token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AccountInfo.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error getting account info: $e');
      return null;
    }
  }

  static Future getPhoneNumbers(String login, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.phoneEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Login': login, 'Token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['Phone'] ?? data['PhoneNumber'];
      }
      return null;
    } catch (e) {
      print('Error getting phone: $e');
      return null;
    }
  }

  static Future<List> getTrades(String login, String token) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.tradesEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Login': login, 'Token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List tradesJson = data['Trades'] ?? data['OpenTrades'] ?? [];
        return tradesJson.map((json) => Trade.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting trades: $e');
      return [];
    }
  }
}
