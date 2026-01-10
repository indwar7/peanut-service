class Trade {
  final int id;
  final String symbol;
  final String type;
  final double volume;
  final double openPrice;
  final double? closePrice;
  final double profit;
  final DateTime openTime;
  final DateTime? closeTime;

  Trade({
    required this.id,
    required this.symbol,
    required this.type,
    required this.volume,
    required this.openPrice,
    this.closePrice,
    required this.profit,
    required this.openTime,
    this.closeTime,
  });

  factory Trade.fromJson(Map json) {
    return Trade(
      id: json['Id'] ?? json['OrderId'] ?? 0,
      symbol: json['Symbol'] ?? '',
      type: json['Type'] ?? json['TradeType'] ?? '',
      volume: (json['Volume'] ?? json['Lots'] ?? 0).toDouble(),
      openPrice: (json['OpenPrice'] ?? json['Price'] ?? 0).toDouble(),
      closePrice: json['ClosePrice']?.toDouble(),
      profit: (json['Profit'] ?? 0).toDouble(),
      openTime: DateTime.parse(
        json['OpenTime'] ??
            json['OpenDate'] ??
            DateTime.now().toIso8601String(),
      ),
      closeTime: json['CloseTime'] != null
          ? DateTime.parse(json['CloseTime'])
          : null,
    );
  }
}
