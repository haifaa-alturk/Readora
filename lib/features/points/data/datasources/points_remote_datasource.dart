import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/points_history_entry_model.dart';

abstract class PointsRemoteDataSource {
  Future<int> getTotalPoints();
  Future<List<PointsHistoryEntryModel>> getPointsHistory();
  Future<List<PointsHistoryEntryModel>> addPoints({required int amount, required String source});
}

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  PointsRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  int? _cachedTotal;
  List<PointsHistoryEntryModel>? _cachedHistory;

  Future<void> _ensureLoaded() async {
    if (_cachedTotal != null && _cachedHistory != null) return;
    if (useMockData) {
      final totalData = MockDataProvider.totalPoints();
      _cachedTotal = totalData['total_points'] as int;
      final historyData = MockDataProvider.pointsHistory();
      _cachedHistory = historyData
          .map((e) => PointsHistoryEntryModel.fromJson(e))
          .toList();
      return;
    }
    // TODO: confirm real points endpoints with backend team
    // final response = await _apiClient.get('/points/total');
    // _cachedTotal = (response.data['total_points'] as num).toInt();
    // final historyResponse = await _apiClient.get('/points/history');
    // final list = historyResponse.data as List<dynamic>;
    // _cachedHistory = list
    //     .map((e) => PointsHistoryEntryModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final totalData = MockDataProvider.totalPoints();
    _cachedTotal = totalData['total_points'] as int;
    final historyData = MockDataProvider.pointsHistory();
    _cachedHistory = historyData
        .map((e) => PointsHistoryEntryModel.fromJson(e))
        .toList();
  }

  @override
  Future<int> getTotalPoints() async {
    await _ensureLoaded();
    return _cachedTotal!;
  }

  @override
  Future<List<PointsHistoryEntryModel>> getPointsHistory() async {
    await _ensureLoaded();
    return List.from(_cachedHistory!);
  }

  @override
  Future<List<PointsHistoryEntryModel>> addPoints({
    required int amount,
    required String source,
  }) async {
    await _ensureLoaded();
    final entry = PointsHistoryEntryModel(
      id: DateTime.now().millisecondsSinceEpoch,
      pointsAmount: amount,
      source: source,
      date: DateTime.now(),
    );
    _cachedHistory!.insert(0, entry);
    _cachedTotal = _cachedTotal! + amount;
    // Real implementation would POST to a points endpoint and use the server's authoritative total/history.
    return List.from(_cachedHistory!);
  }
}