import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.balance,
    required super.points,
    super.currency = 'SYP',
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final walletValue =
        json['wallet'] ?? json['wallet_balance'] ?? json['balance'] ?? 0;

    final pointsValue = json['points'] ?? json['total_points'] ?? 0;

    final currencyValue = json['currency']?.toString() ?? 'SYP';

    return WalletModel(
      balance: _parseDouble(walletValue),
      points: _parseInt(pointsValue),
      currency: currencyValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {'wallet': balance, 'points': points, 'currency': currency};
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '0') ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }
}
