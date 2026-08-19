import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/profile_model.dart';
import '../models/purchase_history_model.dart';

class ProfileRemoteDataSource {
  final ApiClient _realApiClient;
  ProfileModel? _cachedProfile;

  ProfileRemoteDataSource(this._realApiClient);

  Future<ProfileModel> getProfile() async {
    final userFuture = _realApiClient.dio.get('user');
    final booksCountFuture = getBooksCount();

    final response = await userFuture;
    final booksCount = await booksCountFuture;

    final json = Map<String, dynamic>.from(response.data as Map);
    final freshUserId = json['id'] as int? ?? json['user_id'] as int?;
    // لا نعيد استخدام الكاش القديم إذا تغيّر الحساب (مختلف الـ id)
    final previous = (_cachedProfile != null &&
            freshUserId != null &&
            _cachedProfile!.userId == freshUserId)
        ? _cachedProfile
        : null;

    _cachedProfile = _profileFromUserJson(
      json,
      previous: previous,
      fallbackName: previous?.name ?? 'lara',
      fallbackEmail: previous?.email ?? 'lara@test.com',
      booksCount: booksCount,
    );

    return _cachedProfile!;
  }

  Future<int> getBooksCount() async {
    final response = await _realApiClient.dio.get('user/my-books');
    final json = Map<String, dynamic>.from(response.data as Map);
    return json['total_books'] as int? ?? 0;
  }

  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (imagePath != null) 'user_image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _realApiClient.dio.post('profile_update', data: formData);
    final json = _extractUserPayload(response.data);
    final previous = _cachedProfile;

    _cachedProfile = _profileFromUserJson(
      json,
      previous: previous,
      fallbackName: name,
      fallbackEmail: email,
    );

    return _cachedProfile!;
  }

  Future<ProfileModel> updateProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'user_image': await MultipartFile.fromFile(filePath),
    });

    final response = await _realApiClient.dio.post('profile_update', data: formData);
    final json = _extractUserPayload(response.data);
    final previous = _cachedProfile;

    _cachedProfile = _profileFromUserJson(
      json,
      previous: previous,
      fallbackImagePath: filePath,
      fallbackName: previous?.name ?? 'lara',
      fallbackEmail: previous?.email ?? 'lara@test.com',
    );

    return _cachedProfile!;
  }

  Future<List<PurchaseHistoryModel>> getPurchaseHistory() async {
    final response = await _realApiClient.dio.get('user/purchases-history');
    final json = Map<String, dynamic>.from(response.data as Map);
    final history = json['history'] as List<dynamic>? ?? [];
    return history
        .map((e) => PurchaseHistoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Map<String, dynamic> _extractUserPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) {
        return user;
      }
      return data;
    }

    return Map<String, dynamic>.from(data as Map);
  }

  ProfileModel _profileFromUserJson(
    Map<String, dynamic> json, {
    ProfileModel? previous,
    String? fallbackName,
    String? fallbackEmail,
    String? fallbackImagePath,
    int? booksCount,
  }) {
    return ProfileModel(
      userId: json['id'] as int? ?? json['user_id'] as int? ?? previous?.userId ?? 0,
      name: json['name'] as String? ?? fallbackName ?? previous?.name ?? '',
      email: json['email'] as String? ?? fallbackEmail ?? previous?.email ?? '',
      points: int.tryParse(json['points']?.toString() ?? '') ?? previous?.points ?? 0,
      booksCount: booksCount ?? previous?.booksCount ?? 5,
      walletBalance:
          num.tryParse(json['wallet']?.toString() ?? '')?.toDouble() ??
          previous?.walletBalance ??
          250.0,
      imagePath: json['user_image'] as String? ?? fallbackImagePath ?? previous?.imagePath,
    );
  }
}