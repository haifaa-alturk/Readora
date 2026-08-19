import '../../../../core/api/api_client.dart';
import '../models/wallet_model.dart';
import '../models/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWalletBalance();
  Future<List<WalletTransactionModel>> getTransactionHistory();
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSourceImpl(this._apiClient);

  @override
  Future<WalletModel> getWalletBalance() async {
    final response = await _apiClient.dio.get('user/wallet_transaction');
    final json = Map<String, dynamic>.from(response.data as Map);
    return WalletModel.fromJson(json);
  }

  @override
  Future<List<WalletTransactionModel>> getTransactionHistory() async {
    final response = await _apiClient.dio.get('user/wallet_transaction');
    final json = Map<String, dynamic>.from(response.data as Map);
    final raw = json['transactions'];
    final transactions = raw is List ? raw : <dynamic>[];
    return transactions
        .map((e) => WalletTransactionModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}