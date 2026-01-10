class LoginRequest {
  final String login;
  final String password;

  LoginRequest({required this.login, required this.password});

  Map toJson() {
    return {'Login': login, 'Password': password};
  }
}
