import 'package:dartz/dartz.dart';

import '../entities/wallet_entity.dart';
import '../entities/wallet_transaction_entity.dart';

abstract class WalletRepositoryInterface {
  Future<Either<String, WalletEntity>> getWalletBalance();

  Future<Either<String, List<WalletTransactionEntity>>> getTransactionHistory();

  Future<Either<String, String>> rechargeWallet({
    required double amount,
    required String receiptImagePath,
  });
}
