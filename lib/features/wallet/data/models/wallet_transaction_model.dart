import '../../domain/entities/wallet_transaction_entity.dart';

class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    required super.id,
    required super.amount,
    required super.source,
    required super.date,
    required super.type,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    final rawType = (json['type'] as String? ?? '').toLowerCase();
    final isCredit = rawType == 'recharge' || rawType == 'credit';
    final source = rawType == 'recharge'
        ? 'Wallet Recharge'
        : rawType == 'purchase'
            ? 'Book Purchase'
            : rawType == 'borrow'
                ? 'Book Borrow'
                : json['source'] as String? ?? rawType;

    return WalletTransactionModel(
      id: int.tryParse('${json['id']}') ?? 0,
      amount: (_parseAmount(json['amount']) ?? 0.0).abs(),
      source: source,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      type: isCredit ? 'credit' : 'debit',
    );
  }

  static double? _parseAmount(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'date': date.toIso8601String(),
      'type': type,
    };
  }
}