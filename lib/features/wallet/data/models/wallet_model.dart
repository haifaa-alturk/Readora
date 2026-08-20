import '../../domain/entities/wallet_entity.dart';

class WalletModel extends WalletEntity {
  const WalletModel({
    required super.balance,
    required super.points,
    super.currency = 'SYP',
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final walletValue =
        json['wallet'] ?? json['wallet_balance'] ?? json['balance'];

    final pointsValue = json['points'] ?? json['total_points'] ?? 0;

    return WalletModel(
      balance: walletValue is num
          ? walletValue.toDouble()
          : double.tryParse(walletValue?.toString() ?? '0') ?? 0.0,
      points: pointsValue is num
          ? pointsValue.toInt()
          : int.tryParse(pointsValue?.toString() ?? '0') ?? 0,
      currency: json['currency']?.toString() ?? 'SYP',
    );
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance, 'points': points, 'currency': currency};
  }
}
