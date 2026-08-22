import 'package:equatable/equatable.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

class WalletInitial extends WalletState {
  const WalletInitial();
}

// ============================================================
// LOADING
// ============================================================

class WalletLoading extends WalletState {
  const WalletLoading();
}

// ============================================================
// LOADED
// ============================================================

class WalletLoaded extends WalletState {
  final WalletEntity wallet;
  final List<WalletTransactionEntity> transactions;

  const WalletLoaded({required this.wallet, required this.transactions});

  @override
  List<Object?> get props => [wallet, transactions];
}

// ============================================================
// ERROR
// ============================================================

class WalletError extends WalletState {
  final String message;

  const WalletError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================
// RECHARGE LOADING
// ============================================================

class WalletRechargeLoading extends WalletState {
  const WalletRechargeLoading();
}

// ============================================================
// RECHARGE SUCCESS
// ============================================================

class WalletRechargeSuccess extends WalletState {
  final String message;

  const WalletRechargeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================
// RECHARGE ERROR
// ============================================================

class WalletRechargeError extends WalletState {
  final String message;

  const WalletRechargeError({required this.message});

  @override
  List<Object?> get props => [message];
}
