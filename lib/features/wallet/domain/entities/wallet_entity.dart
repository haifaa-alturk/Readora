class WalletEntity {
  final double balance;
  final String currency;

  const WalletEntity({
    required this.balance,
    this.currency = 'SYP',
  });
}