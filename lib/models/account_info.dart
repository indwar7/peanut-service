class AccountInfo {
  final String login;
  final String? name;
  final String? email;
  final String? phone;
  final double? balance;
  final String? currency;

  AccountInfo({
    required this.login,
    this.name,
    this.email,
    this.phone,
    this.balance,
    this.currency,
  });

  factory AccountInfo.fromJson(Map json) {
    return AccountInfo(
      login: json['Login']?.toString() ?? '',
      name: json['Name'],
      email: json['Email'],
      phone: json['Phone'],
      balance: json['Balance']?.toDouble(),
      currency: json['Currency'],
    );
  }
}
