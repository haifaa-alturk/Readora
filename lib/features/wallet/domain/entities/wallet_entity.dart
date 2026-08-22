class WalletEntity {
  final double balance;
  final int points;
  final String currency;

  const WalletEntity({
    required this.balance,
    required this.points,
    this.currency = 'SYP',
  });
}
