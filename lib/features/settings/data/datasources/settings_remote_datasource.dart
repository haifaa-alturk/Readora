import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/settings_model.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsModel> getSettings();
  Future<SettingsModel> updateSettings(SettingsModel settings);
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;
  SettingsModel? _cachedSettings;

  @override
  Future<SettingsModel> getSettings() async {
    if (_cachedSettings != null) return _cachedSettings!;

    if (useMockData) {
      _cachedSettings = const SettingsModel();
      return _cachedSettings!;
    }
    // TODO: confirm real settings endpoints with backend team
    // final response = await _apiClient.get('/settings');
    // _cachedSettings = SettingsModel.fromJson(response.data as Map<String, dynamic>);
    // return _cachedSettings!;
    _cachedSettings = const SettingsModel();
    return _cachedSettings!;
  }

  @override
  Future<SettingsModel> updateSettings(SettingsModel settings) async {
    if (useMockData) {
      _cachedSettings = settings;
      return _cachedSettings!;
    }
    // TODO: confirm real settings endpoints with backend team
    // final response = await _apiClient.put('/settings', data: settings.toJson());
    // _cachedSettings = SettingsModel.fromJson(response.data as Map<String, dynamic>);
    // return _cachedSettings!;
    _cachedSettings = settings;
    return _cachedSettings!;
  }
}