import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/win_model.dart';

abstract class WinsRemoteDataSource {
  Future<List<WinModel>> getWins();
  Future<List<WinModel>> addWin(WinModel win);
  Future<List<WinModel>> removeWin(int winId);
}

class WinsRemoteDataSourceImpl implements WinsRemoteDataSource {
  WinsRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  List<WinModel>? _cachedWins;

  void _sortNewestFirst() {
    _cachedWins!.sort((a, b) {
      final aDate = a.completedDate ?? a.dateEarned ?? DateTime(0);
      final bDate = b.completedDate ?? b.dateEarned ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
  }

  Future<List<WinModel>> _ensureLoaded() async {
    if (_cachedWins != null) return List.from(_cachedWins!);
    if (useMockData) {
      final data = MockDataProvider.winsList();
      _cachedWins = data.map((e) => WinModel.fromJson(e)).toList();
    } else {
      // TODO: confirm real wins endpoint URL with backend team
      // import 'package:dev3/core/network/endpoints.dart' shows Endpoints.wins
      // final response = await _apiClient.get('/wins');
      // final list = response.data as List<dynamic>;
      // _cachedWins = list
      //     .map((e) => WinModel.fromJson(e as Map<String, dynamic>))
      //     .toList();
      final data = MockDataProvider.winsList();
      _cachedWins = data.map((e) => WinModel.fromJson(e)).toList();
    }
    _sortNewestFirst();
    return List.from(_cachedWins!);
  }

  @override
  Future<List<WinModel>> getWins() async {
    return _ensureLoaded();
  }

  @override
  Future<List<WinModel>> addWin(WinModel win) async {
    await _ensureLoaded();
    _cachedWins!.insert(0, win);
    _sortNewestFirst();
    // Real implementation would POST to a wins endpoint and return the server's authoritative list.
    return List.from(_cachedWins!);
  }

  @override
  Future<List<WinModel>> removeWin(int winId) async {
    await _ensureLoaded();
    _cachedWins!.removeWhere((w) => w.id == winId);
    _sortNewestFirst();
    // Real implementation would DELETE to a wins endpoint and return the server's authoritative list.
    return List.from(_cachedWins!);
  }
}