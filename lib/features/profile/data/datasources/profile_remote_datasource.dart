import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../../../../core/network_dev3/endpoints.dart';
import '../models/profile_model.dart';
import '../models/purchase_history_model.dart';

class ProfileRemoteDataSource {
  final Dev3ApiClient _apiClient;
  ProfileModel? _cachedProfile;

  ProfileRemoteDataSource(this._apiClient);

  Future<ProfileModel> getProfile() async {
    if (_cachedProfile != null) return _cachedProfile!;
    if (useMockData) {
      return const ProfileModel(
        userId: 1,
        name: "lara",
        email: "lara@test.com",
        points: 100,
        booksCount: 5,
        walletBalance: 250.0,
        imagePath: null,
      );
    }
    final response = await _apiClient.get(Endpoints.profile);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'email': email,
      if (imagePath != null) 'image_path': imagePath,
    };
    if (useMockData) {
      final previous = _cachedProfile;
      _cachedProfile = ProfileModel(
        userId: previous?.userId ?? 1,
        name: name,
        email: email,
        points: previous?.points ?? 100,
        booksCount: previous?.booksCount ?? 5,
        walletBalance: previous?.walletBalance ?? 250.0,
        imagePath: imagePath ?? previous?.imagePath,
      );
      return _cachedProfile!;
    }
    final response = await _apiClient.put(Endpoints.updateProfile, data: data);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<ProfileModel> updateProfileImage(String filePath) async {
    if (useMockData) {
      final previous = _cachedProfile;
      _cachedProfile = ProfileModel(
        userId: previous?.userId ?? 1,
        name: previous?.name ?? "lara",
        email: previous?.email ?? "lara@test.com",
        points: previous?.points ?? 100,
        booksCount: previous?.booksCount ?? 5,
        walletBalance: previous?.walletBalance ?? 250.0,
        imagePath: filePath,
      );
      return _cachedProfile!;
    }
    final response = await _apiClient.uploadFile(
      Endpoints.uploadProfileImage,
      filePath: filePath,
      fieldName: 'image',
    );
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<PurchaseHistoryModel>> getPurchaseHistory() async {
    if (useMockData) {
      final data = MockDataProvider.purchaseHistoryList();
      return data.map((e) => PurchaseHistoryModel.fromJson(e)).toList();
    }
    final response = await _apiClient.get(Endpoints.purchaseHistory);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => PurchaseHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}