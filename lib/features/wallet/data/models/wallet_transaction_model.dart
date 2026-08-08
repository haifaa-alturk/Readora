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
    return WalletTransactionModel(
      id: json['id'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      type: json['type'] as String? ?? 'credit',
    );
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