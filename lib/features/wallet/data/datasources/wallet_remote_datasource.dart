import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWalletBalance();
  Future<List<WalletTransactionModel>> getTransactionHistory();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  WalletRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  @override
  Future<WalletModel> getWalletBalance() async {
    if (useMockData) {
      return WalletModel.fromJson(MockDataProvider.walletBalance());
    }
    // TODO: confirm real wallet endpoints with backend team
    // final response = await _apiClient.get('/wallet/balance');
    // return WalletModel.fromJson(response.data as Map<String, dynamic>);
    return WalletModel.fromJson(MockDataProvider.walletBalance());
  }

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    if (useMockData) {
      final data = MockDataProvider.walletTransactions();
      return data.map((e) => WalletTransactionModel.fromJson(e)).toList();
    }
    // TODO: confirm real wallet endpoints with backend team
    // final response = await _apiClient.get('/wallet/transactions');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => WalletTransactionModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.walletTransactions();
    return data.map((e) => WalletTransactionModel.fromJson(e)).toList();
  }
}