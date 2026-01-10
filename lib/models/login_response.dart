class LoginResponse {
  final bool isSuccessful;
  final String? token;
  final String? message;

  LoginResponse({required this.isSuccessful, this.token, this.message});

  factory LoginResponse.fromJson(Map json) {
    return LoginResponse(
      isSuccessful: json['IsSuccessful'] ?? false,
      token: json['Token'],
      message: json['Message'],
    );
  }
}
