import 'package:dartz/dartz.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/repositories/wallet_repository_interface.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepositoryInterface {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, WalletEntity>> getWalletBalance() async {
    try {
      final result = await _remoteDataSource.getWalletBalance();
      return Right(result);
    } catch (e) {
      return Left('Error fetching wallet balance: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<WalletTransactionEntity>>>
      getTransactionHistory() async {
    try {
      final result = await _remoteDataSource.getTransactionHistory();
      return Right(result);
    } catch (e) {
      return Left('Error fetching transaction history: ${e.toString()}');
    }
  }
}