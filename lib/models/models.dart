class AccountInfo {
  final String address;
  final double balance;
  final String city;
  final String country;
  final int currency;
  final int currentTradesCount;
  final double currentTradesVolume;
  final double equity;
  final double freeMargin;
  final bool isAnyOpenTrades;
  final bool isSwapFree;
  final int leverage;
  final String name;
  final String phone;
  final int totalTradesCount;
  final double totalTradesVolume;
  final int type;
  final int verificationLevel;
  final String zipCode;

  AccountInfo({
    required this.address,
    required this.balance,
    required this.city,
    required this.country,
    required this.currency,
    required this.currentTradesCount,
    required this.currentTradesVolume,
    required this.equity,
    required this.freeMargin,
    required this.isAnyOpenTrades,
    required this.isSwapFree,
    required this.leverage,
    required this.name,
    required this.phone,
    required this.totalTradesCount,
    required this.totalTradesVolume,
    required this.type,
    required this.verificationLevel,
    required this.zipCode,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      address: json['address'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      currency: json['currency'] ?? 0,
      currentTradesCount: json['currentTradesCount'] ?? 0,
      currentTradesVolume: (json['currentTradesVolume'] ?? 0).toDouble(),
      equity: (json['equity'] ?? 0).toDouble(),
      freeMargin: (json['freeMargin'] ?? 0).toDouble(),
      isAnyOpenTrades: json['isAnyOpenTrades'] ?? false,
      isSwapFree: json['isSwapFree'] ?? false,
      leverage: json['leverage'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      totalTradesCount: json['totalTradesCount'] ?? 0,
      totalTradesVolume: (json['totalTradesVolume'] ?? 0).toDouble(),
      type: json['type'] ?? 0,
      verificationLevel: json['verificationLevel'] ?? 0,
      zipCode: json['zipCode'] ?? '',
    );
  }

  String get currencySymbol {
    switch (currency) {
      case 0:
        return '\$';
      case 1:
        return '€';
      case 2:
        return '£';
      default:
        return '\$';
    }
  }
}

class Trade {
  final double closePrice;
  final DateTime? closeTime;
  final String comment;
  final int digits;
  final int login;
  final double openPrice;
  final DateTime openTime;
  final double profit;
  final double sl;
  final double swaps;
  final String symbol;
  final double tp;
  final int ticket;
  final int type;
  final double volume;

  Trade({
    required this.closePrice,
    this.closeTime,
    required this.comment,
    required this.digits,
    required this.login,
    required this.openPrice,
    required this.openTime,
    required this.profit,
    required this.sl,
    required this.swaps,
    required this.symbol,
    required this.tp,
    required this.ticket,
    required this.type,
    required this.volume,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      closePrice: (json['closePrice'] ?? 0).toDouble(),
      closeTime:
          json['closeTime'] != null ? DateTime.parse(json['closeTime']) : null,
      comment: json['comment'] ?? '',
      digits: json['digits'] ?? 0,
      login: json['login'] ?? 0,
      openPrice: (json['openPrice'] ?? 0).toDouble(),
      openTime: DateTime.parse(json['openTime']),
      profit: (json['profit'] ?? 0).toDouble(),
      sl: (json['sl'] ?? 0).toDouble(),
      swaps: (json['swaps'] ?? 0).toDouble(),
      symbol: json['symbol'] ?? '',
      tp: (json['tp'] ?? 0).toDouble(),
      ticket: json['ticket'] ?? 0,
      type: json['type'] ?? 0,
      volume: (json['volume'] ?? 0).toDouble(),
    );
  }

  String get tradeType {
    switch (type) {
      case 0:
        return 'BUY';
      case 1:
        return 'SELL';
      case 2:
        return 'BUY LIMIT';
      case 3:
        return 'SELL LIMIT';
      case 4:
        return 'BUY STOP';
      case 5:
        return 'SELL STOP';
      case 6:
        return 'BALANCE';
      default:
        return 'UNKNOWN';
    }
  }

  bool get isProfitable => profit > 0;
  bool get isOpen => closeTime == null;
}

class BalanceOperation {
  final int account;
  final double amount;
  final DateTime date;
  final int operationId;
  final int operationType;
  final String paymentSystem;
  final int status;
  final int ticket;

  BalanceOperation({
    required this.account,
    required this.amount,
    required this.date,
    required this.operationId,
    required this.operationType,
    required this.paymentSystem,
    required this.status,
    required this.ticket,
  });

  factory BalanceOperation.fromJson(Map<String, dynamic> json) {
    return BalanceOperation(
      account: json['account'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      operationId: json['operationId'] ?? 0,
      operationType: json['operationType'] ?? 0,
      paymentSystem: json['paymentSystem'] ?? '',
      status: json['status'] ?? 0,
      ticket: json['ticket'] ?? 0,
    );
  }

  String get operationTypeText {
    switch (operationType) {
      case 0:
        return 'Deposit';
      case 1:
        return 'Withdrawal';
      default:
        return 'Unknown';
    }
  }

  String get statusText {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Completed';
      case 2:
        return 'Failed';
      default:
        return 'Unknown';
    }
  }
}

class BonusStatistic {
  final double clubBonus;
  final double totalBonus;
  final double welcomeBonus;
  final double availableToWithdraw;
  final double availableToWithdrawWithoutLosingBonus;
  final double balance;
  final double equity;
  final double freeMargin;
  final int bonusState;
  final double closedLots;
  final double lotsRequired;
  final double missingLots;

  BonusStatistic({
    required this.clubBonus,
    required this.totalBonus,
    required this.welcomeBonus,
    required this.availableToWithdraw,
    required this.availableToWithdrawWithoutLosingBonus,
    required this.balance,
    required this.equity,
    required this.freeMargin,
    required this.bonusState,
    required this.closedLots,
    required this.lotsRequired,
    required this.missingLots,
  });

  factory BonusStatistic.fromJson(Map<String, dynamic> json) {
    final bonuses = json['bonuses'] ?? {};
    final summary = json['summary'] ?? {};
    final trade = json['trade'] ?? {};

    return BonusStatistic(
      clubBonus: (bonuses['clubBonus'] ?? 0).toDouble(),
      totalBonus: (bonuses['totalBonus'] ?? 0).toDouble(),
      welcomeBonus: (bonuses['welcomeBonus'] ?? 0).toDouble(),
      availableToWithdraw: (summary['availableToWithdraw'] ?? 0).toDouble(),
      availableToWithdrawWithoutLosingBonus:
          (summary['availableToWithdrawWithoutLosingBonus'] ?? 0).toDouble(),
      balance: (summary['balance'] ?? 0).toDouble(),
      equity: (summary['equity'] ?? 0).toDouble(),
      freeMargin: (summary['freeMargin'] ?? 0).toDouble(),
      bonusState: trade['bonusState'] ?? 0,
      closedLots: (trade['closedLots'] ?? 0).toDouble(),
      lotsRequired: (trade['lotsRequired'] ?? 0).toDouble(),
      missingLots: (trade['missingLots'] ?? 0).toDouble(),
    );
  }
}
