import 'package:dio/dio.dart';

import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';

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
  WalletRemoteDataSourceImpl(this._apiClient);

  final Dev3ApiClient _apiClient;

  @override
  Future<WalletModel> getWalletBalance() async {
    if (useMockData) {
      return WalletModel.fromJson(MockDataProvider.walletBalance());
    }

    final response = await _apiClient.get('/user');

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return WalletModel.fromJson(data);
    }

    throw Exception('Invalid user response from server');
  }

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    if (useMockData) {
      final data = MockDataProvider.walletTransactions();

      return data.map((item) => WalletTransactionModel.fromJson(item)).toList();
    }

    // لا يوجد حالياً endpoint للمعاملات في الباك.
    return <WalletTransactionModel>[];
  }

  @override
  Future<String> rechargeWallet({
    required double amount,
    required String receiptImagePath,
  }) async {
    if (useMockData) {
      return 'تم إرسال طلب الشحن بنجاح، بانتظار موافقة الأدمن';
    }

    final formData = FormData.fromMap({
      'amount': amount,
      'receipt_image': await MultipartFile.fromFile(
        receiptImagePath,
        filename: receiptImagePath.split('/').last,
      ),
    });

    final response = await _apiClient.post('/wallet_charge', data: formData);

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          'تم إرسال طلب الشحن بنجاح، بانتظار موافقة الأدمن';
    }

    return 'تم إرسال طلب الشحن بنجاح، بانتظار موافقة الأدمن';
  }
}
