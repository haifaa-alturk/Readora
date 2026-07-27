import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallet_repository_interface.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepositoryInterface repository;

  WalletBloc({required this.repository}) : super(const WalletInitial()) {
    on<LoadWalletEvent>(_onLoadWallet);
  }

  Future<void> _onLoadWallet(
    LoadWalletEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());

    final balanceResult = await repository.getWalletBalance();
    final historyResult = await repository.getTransactionHistory();

    balanceResult.fold(
      (error) => emit(WalletError(message: error)),
      (wallet) {
        historyResult.fold(
          (error) => emit(WalletError(message: error)),
          (transactions) {
            emit(WalletLoaded(wallet: wallet, transactions: transactions));
          },
        );
      },
    );
  }
}