import '../../../../core/api/api_client.dart';
import '../models/points_history_entry_model.dart';

abstract class PointsRemoteDataSource {
  Future<int> getTotalPoints();
  Future<List<PointsHistoryEntryModel>> getPointsHistory();
  Future<List<PointsHistoryEntryModel>> addPoints({
    required int amount,
    required String source,
  });
}

class PointsRemoteDataSourceImpl implements PointsRemoteDataSource {
  PointsRemoteDataSourceImpl(this._realApiClient);

  final ApiClient _realApiClient;

  int? _cachedTotal;
  List<PointsHistoryEntryModel>? _cachedHistory;

  Future<void> _ensureLoaded({bool force = false}) async {
    if (!force && _cachedTotal != null && _cachedHistory != null) return;

    final response = await _realApiClient.dio.get('user/points_history');
    final json = Map<String, dynamic>.from(response.data as Map);

    _cachedTotal = json['total_points'] as int? ?? 0;
    final history = json['history'] as List<dynamic>? ?? const [];
    _cachedHistory = history
        .map(
          (e) => PointsHistoryEntryModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
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
    await _ensureLoaded(force: true);
    return List.from(_cachedHistory!);
  }
}
