class WalletTransactionEntity {
  final int id;
  final double amount;
  final String source;
  final DateTime date;
  final String type;

  const WalletTransactionEntity({
    required this.id,
    required this.amount,
    required this.source,
    required this.date,
    required this.type,
  });

  bool get isCredit => type == 'credit';

  bool get isDebit => type == 'debit';
}
