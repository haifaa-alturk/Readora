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
    final rawAmount = json['amount'] ?? json['value'] ?? 0;

    final amount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse(rawAmount.toString()) ?? 0.0;

    final id = _parseId(json['id']);

    final rawDate = json['date'] ?? json['created_at'] ?? json['createdAt'];

    final date = rawDate != null
        ? DateTime.tryParse(rawDate.toString()) ?? DateTime.now()
        : DateTime.now();

    final backendType =
        (json['type'] ?? json['transaction_type'] ?? json['source'] ?? '')
            .toString()
            .toLowerCase();

    return WalletTransactionModel(
      id: id,
      amount: amount,
      source: _getSource(backendType, json),
      date: date,
      type: _getTransactionType(backendType, amount),
    );
  }

  // ============================================================
  // ID
  // ============================================================

  static int _parseId(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    final stringValue = value?.toString() ?? '';

    final numericId = int.tryParse(stringValue);

    if (numericId != null) {
      return numericId;
    }

    return stringValue.hashCode;
  }

  // ============================================================
  // SOURCE
  // ============================================================

  static String _getSource(String backendType, Map<String, dynamic> json) {
    switch (backendType) {
      case 'recharge':
      case 'charging':
      case 'wallet_charge':
        return 'شحن المحفظة';

      case 'purchase':
      case 'buy':
        return 'شراء كتاب';

      case 'borrow':
      case 'rent':
      case 'borrowing':
        return 'استعارة كتاب';

      default:
        final source = json['source']?.toString();

        if (source != null && source.trim().isNotEmpty) {
          return source;
        }

        return backendType.isNotEmpty ? backendType : 'عملية محفظة';
    }
  }

  // ============================================================
  // CREDIT / DEBIT
  // ============================================================

  static String _getTransactionType(String backendType, double amount) {
    switch (backendType) {
      case 'recharge':
      case 'charging':
      case 'wallet_charge':
        return 'credit';

      case 'purchase':
      case 'buy':
      case 'borrow':
      case 'rent':
      case 'borrowing':
        return 'debit';

      default:
        return amount >= 0 ? 'credit' : 'debit';
    }
  }

  // ============================================================
  // JSON
  // ============================================================

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
