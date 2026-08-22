import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallet_repository_interface.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepositoryInterface repository;

  WalletBloc({required this.repository}) : super(const WalletInitial()) {
    on<LoadWalletEvent>(_onLoadWallet);
    on<RechargeWalletEvent>(_onRechargeWallet);
  }

  // ============================================================
  // LOAD WALLET
  // ============================================================

  Future<void> _onLoadWallet(
    LoadWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    try {
      final balanceResult = await repository.getWalletBalance();

      final historyResult = await repository.getTransactionHistory();

      final wallet = balanceResult.fold(
        (error) => throw Exception(error),
        (value) => value,
      );

      final transactions = historyResult.fold(
        (error) => throw Exception(error),
        (value) => value,
      );

      emit(WalletLoaded(wallet: wallet, transactions: transactions));
    } catch (e) {
      emit(WalletError(message: 'حدث خطأ أثناء تحميل بيانات المحفظة: $e'));
    }
  }

  // ============================================================
  // RECHARGE
  // ============================================================

  Future<void> _onRechargeWallet(
    RechargeWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletRechargeLoading());

    try {
      final result = await repository.rechargeWallet(
        amount: event.amount,
        receiptImagePath: event.receiptImagePath,
      );

      result.fold(
        (error) {
          emit(WalletRechargeError(message: error));
        },
        (message) {
          emit(WalletRechargeSuccess(message: message));
        },
      );
    } catch (e) {
      emit(WalletRechargeError(message: 'حدث خطأ أثناء إرسال طلب الشحن: $e'));
    }
  }
}
