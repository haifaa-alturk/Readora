import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/wallet_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/repositories/wallet_repository_interface.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepositoryInterface {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  // ============================================================
  // WALLET BALANCE + POINTS
  // ============================================================

  @override
  Future<Either<String, WalletEntity>> getWalletBalance() async {
    try {
      final wallet = await _remoteDataSource.getWalletBalance();

      return Right(wallet);
    } on DioException catch (e) {
      return Left(_getDioErrorMessage(e));
    } catch (e) {
      return Left('حدث خطأ أثناء جلب رصيد المحفظة: ${e.toString()}');
    }
  }

  // ============================================================
  // TRANSACTION HISTORY
  // ============================================================

  @override
  Future<Either<String, List<WalletTransactionEntity>>>
  getTransactionHistory() async {
    try {
      final transactions = await _remoteDataSource.getTransactionHistory();

      return Right(transactions);
    } on DioException catch (e) {
      return Left(_getDioErrorMessage(e));
    } catch (e) {
      return Left('حدث خطأ أثناء جلب سجل عمليات المحفظة: ${e.toString()}');
    }
  }

  // ============================================================
  // RECHARGE
  // ============================================================

  @override
  Future<Either<String, String>> rechargeWallet({
    required double amount,
    required String receiptImagePath,
  }) async {
    try {
      final message = await _remoteDataSource.rechargeWallet(
        amount: amount,
        receiptImagePath: receiptImagePath,
      );

      return Right(message);
    } on DioException catch (e) {
      return Left(_getDioErrorMessage(e));
    } catch (e) {
      return Left('حدث خطأ أثناء إرسال طلب الشحن: ${e.toString()}');
    }
  }

  // ============================================================
  // DIO ERROR
  // ============================================================

  String _getDioErrorMessage(DioException e) {
    final responseData = e.response?.data;

    if (responseData is Map) {
      final message = responseData['message'];

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }

      final errors = responseData['errors'];

      if (errors is Map) {
        final messages = <String>[];

        for (final value in errors.values) {
          if (value is List) {
            messages.addAll(value.map((item) => item.toString()));
          } else {
            messages.add(value.toString());
          }
        }

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'انتهت مهلة الاتصال بالخادم';
    }

    if (e.type == DioExceptionType.connectionError) {
      return 'تعذر الاتصال بالخادم، تأكدي أن الباكند يعمل';
    }

    return 'حدث خطأ أثناء الاتصال بالخادم';
  }
}
