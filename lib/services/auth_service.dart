import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://peanut.ifxdb.com/api';

  /// Login with account credentials and get access token
  Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ClientCabinetBasic/IsAccountCredentialsCorrect'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': int.tryParse(login) ?? 0,
          'password': password,
        }),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['result'] == true &&
            data['token'] != null &&
            data['token'].toString().isNotEmpty) {
          // Save credentials and token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', data['token']);
          await prefs.setString('user_login', login);
          await prefs.setString(
              'user_password', password); // Save for token refresh
          await prefs.setBool('is_logged_in', true);

          return {
            'success': true,
            'message': 'Login successful!',
            'token': data['token'],
          };
        } else {
          return {
            'success': false,
            'message': 'Invalid login credentials',
          };
        }
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': 'Invalid login or password',
        };
      } else {
        return {
          'success': false,
          'message': 'Login failed. Please try again.',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
  }

  /// Refresh the access token when it expires
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final login = prefs.getString('user_login');
      final password = prefs.getString('user_password');

      if (login == null || password == null) {
        return {
          'success': false,
          'message': 'No saved credentials found',
        };
      }

      // Re-authenticate to get new token
      return await this.login(login, password);
    } catch (e) {
      print('Token refresh error: $e');
      return {
        'success': false,
        'message': 'Failed to refresh token',
      };
    }
  }

  /// Make authenticated API request with automatic token refresh
  Future<http.Response> makeAuthenticatedRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    bool isRetry = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final login = prefs.getString('user_login');

      if (token == null || login == null) {
        throw Exception('Not authenticated');
      }

      // Add login and token to the request body
      final requestBody = {
        ...body,
        'login': int.tryParse(login) ?? 0,
        'token': token,
      };

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // If token expired (401 or 500 with certain error), refresh and retry
      if (!isRetry &&
          (response.statusCode == 401 ||
              (response.statusCode == 500 &&
                  response.body.contains('token')))) {
        print('Token expired, refreshing...');

        final refreshResult = await refreshToken();
        if (refreshResult['success']) {
          // Retry the request with new token
          return await makeAuthenticatedRequest(
            endpoint: endpoint,
            body: body,
            isRetry: true,
          );
        } else {
          throw Exception('Token refresh failed');
        }
      }

      return response;
    } catch (e) {
      print('Authenticated request error: $e');
      rethrow;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final token = prefs.getString('auth_token');
    return isLoggedIn && token != null;
  }

  /// Logout and clear all saved data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_login');
    await prefs.remove('user_password');
    await prefs.remove('is_logged_in');
    await prefs.remove('remembered_login');
  }

  /// Get current token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Get current login
  Future<String?> getLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_login');
  }

  /// Sign up - Not implemented in this API
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    return {
      'success': false,
      'message':
          'Sign up is not available. Please contact support to create an account.',
    };
  }

  /// Forgot password - Not implemented in this API
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return {
      'success': false,
      'message': 'Password reset is not available. Please contact support.',
    };
  }

  /// Example: Get account information with automatic token refresh
  Future<Map<String, dynamic>> getAccountInformation() async {
    try {
      final response = await makeAuthenticatedRequest(
        endpoint: '/ClientCabinetBasic/GetAccountInformation',
        body: {},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to get account information',
        };
      }
    } catch (e) {
      print('Get account info error: $e');
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
