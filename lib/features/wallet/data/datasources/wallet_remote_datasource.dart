import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWalletBalance();

  Future<List<WalletTransactionModel>> getTransactionHistory();

  Future<String> rechargeWallet({
    required double amount,
    required String receiptImagePath,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSourceImpl(this._apiClient);

  // ============================================================
  // GET WALLET + POINTS
  // ============================================================
  //
  // هذا هو الـ endpoint الصحيح من الباك:
  //
  // GET /user/wallet_transaction
  //
  // ويرجع:
  // {
  //   "wallet_balance": 10000,
  //   "points": 150,
  //   "transactions": [...]
  // }
  //
  // لذلك نأخذ منه الرصيد والنقاط الحقيقيين من الباك.
  // ============================================================

  @override
  Future<WalletModel> getWalletBalance() async {
    final response = await _apiClient.dio.get('user/wallet_transaction');

    final data = response.data;

    if (data is! Map) {
      throw Exception('Invalid wallet response from server');
    }

    final mapData = Map<String, dynamic>.from(data);

    return WalletModel.fromJson(mapData);
  }

  // ============================================================
  // TRANSACTIONS
  // ============================================================
  //
  // نفس endpoint يرجع:
  //
  // wallet_balance
  // points
  // transactions
  //
  // ونحن هنا نأخذ فقط transactions.
  // ============================================================

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    final response = await _apiClient.dio.get('user/wallet_transaction');

    final data = response.data;

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => WalletTransactionModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    if (data is! Map) {
      throw Exception('Invalid wallet transactions response from server');
    }

    final mapData = Map<String, dynamic>.from(data);

    final transactionsData = mapData['transactions'];

    if (transactionsData == null) {
      return <WalletTransactionModel>[];
    }

    if (transactionsData is! List) {
      throw Exception('Invalid transactions data from server');
    }

    return transactionsData
        .whereType<Map>()
        .map(
          (item) =>
              WalletTransactionModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  // ============================================================
  // RECHARGE WALLET
  // ============================================================

  @override
  Future<String> rechargeWallet({
    required double amount,
    required String receiptImagePath,
  }) async {
    final fileName = receiptImagePath.split(RegExp(r'[/\\]')).last;

    final formData = FormData.fromMap({
      'amount': amount,
      'receipt_image': await MultipartFile.fromFile(
        receiptImagePath,
        filename: fileName,
      ),
    });

    final response = await _apiClient.dio.post('wallet_charge', data: formData);

    final data = response.data;

    if (data is Map) {
      final message = data['message'];

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }

    return 'تم إرسال طلب الشحن بنجاح، بانتظار موافقة الأدمن';
  }
}
