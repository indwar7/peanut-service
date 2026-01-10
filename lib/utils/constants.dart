class ApiConstants {
  static const String baseUrl = 'https://peanut.ifxdb.com';
  static const String promoBaseUrl = 'https://api-forexcopy.contentdatapro.com';

  // Endpoints
  static const String loginEndpoint =
      '/api/clientcabinet/IsAccountCredentialsCorrect';
  static const String accountInfoEndpoint =
      '/api/clientcabinet/GetAccountInformation';
  static const String phoneEndpoint =
      '/api/clientcabinet/GetLastFourNumbersPhone';
  static const String tradesEndpoint = '/api/clientcabinet/GetOpenTrades';
  static const String promoEndpoint = '/Services/CabinetMicroService.svc';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String loginKey = 'user_login';

  // Test Credentials
  static const String testLogin = '2088888';
  static const String testPassword = 'ral11lod';
}
