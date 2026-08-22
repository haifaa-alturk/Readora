import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// LOAD WALLET
// ============================================================

class LoadWalletEvent extends WalletEvent {
  const LoadWalletEvent();
}

// ============================================================
// RECHARGE
// ============================================================

class RechargeWalletEvent extends WalletEvent {
  final double amount;
  final String receiptImagePath;

  const RechargeWalletEvent({
    required this.amount,
    required this.receiptImagePath,
  });

  @override
  List<Object?> get props => [amount, receiptImagePath];
}
