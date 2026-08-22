import 'package:dio/dio.dart';

import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../../../../core/network_dev3/endpoints.dart';
import '../../../../core/api/api_client.dart';

import '../models/profile_model.dart';
import '../models/purchase_history_model.dart';

class ProfileRemoteDataSource {
  final Dev3ApiClient _apiClient;

  // ApiClient الحقيقي المستخدم مع Laravel
  final ApiClient _realApiClient;

  ProfileModel? _cachedProfile;

  ProfileRemoteDataSource(this._apiClient, this._realApiClient);

  // ============================================================
  // GET PROFILE
  // ============================================================

  Future<ProfileModel> getProfile() async {
    /*
      مهم:

      نحن نستخدم ApiClient الحقيقي هنا وليس MockDataProvider.

      endpoint:
      GET /api/user

      وبالتالي points + wallet تأتي من Laravel.
    */

    final response = await _realApiClient.dio.get('user');

    final data = response.data;

    if (data is! Map) {
      throw Exception('Invalid profile response from server');
    }

    final json = Map<String, dynamic>.from(data);

    final previous = _cachedProfile;

    _cachedProfile = _profileFromUserJson(
      json,
      previous: previous,
      fallbackName: previous?.name ?? '',
      fallbackEmail: previous?.email ?? '',
    );

    return _cachedProfile!;
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    String? imagePath,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (imagePath != null)
        'user_image': await MultipartFile.fromFile(imagePath),
    });

    final response = await _realApiClient.dio.post(
      'profile_update',
      data: formData,
    );

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

  // ============================================================
  // UPDATE PROFILE IMAGE
  // ============================================================

  Future<ProfileModel> updateProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'user_image': await MultipartFile.fromFile(filePath),
    });

    final response = await _realApiClient.dio.post(
      'profile_update',
      data: formData,
    );

    final json = _extractUserPayload(response.data);

    final previous = _cachedProfile;

    _cachedProfile = _profileFromUserJson(
      json,
      previous: previous,
      fallbackImagePath: filePath,
      fallbackName: previous?.name ?? '',
      fallbackEmail: previous?.email ?? '',
    );

    return _cachedProfile!;
  }

  // ============================================================
  // PURCHASE HISTORY
  // ============================================================

  Future<List<PurchaseHistoryModel>> getPurchaseHistory() async {
    if (useMockData) {
      final data = MockDataProvider.purchaseHistoryList();

      return data.map((e) => PurchaseHistoryModel.fromJson(e)).toList();
    }

    final response = await _apiClient.get(Endpoints.purchaseHistory);

    final data = response.data;

    if (data is! List) {
      throw Exception('Invalid purchase history response from server');
    }

    return data
        .whereType<Map>()
        .map((e) => PurchaseHistoryModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  // ============================================================
  // EXTRACT USER PAYLOAD
  // ============================================================

  Map<String, dynamic> _extractUserPayload(dynamic data) {
    if (data is! Map) {
      throw Exception('Invalid user response from server');
    }

    final map = Map<String, dynamic>.from(data);

    final user = map['user'];

    if (user is Map) {
      return Map<String, dynamic>.from(user);
    }

    return map;
  }

  // ============================================================
  // PROFILE FROM JSON
  // ============================================================

  ProfileModel _profileFromUserJson(
    Map<String, dynamic> json, {
    ProfileModel? previous,
    String? fallbackName,
    String? fallbackEmail,
    String? fallbackImagePath,
  }) {
    /*
      أحياناً response الـ user يكون:

      {
        "user": {...}
      }

      لذلك نفك user إذا كان موجوداً.
    */

    final Map<String, dynamic> source;

    if (json['user'] is Map) {
      source = Map<String, dynamic>.from(json['user'] as Map);
    } else {
      source = json;
    }

    // ==========================================================
    // USER ID
    // ==========================================================

    final userId =
        _parseInt(source['id']) ??
        _parseInt(source['user_id']) ??
        previous?.userId ??
        0;

    // ==========================================================
    // NAME
    // ==========================================================

    final name =
        source['name']?.toString() ?? fallbackName ?? previous?.name ?? '';

    // ==========================================================
    // EMAIL
    // ==========================================================

    final email =
        source['email']?.toString() ?? fallbackEmail ?? previous?.email ?? '';

    // ==========================================================
    // POINTS
    // ==========================================================
    //
    // النقاط الحقيقية من Laravel.
    //
    // لا يوجد Mock.
    // لا يوجد رقم ثابت.
    //
    // إذا response فيه points نستخدمه مباشرة.
    // وإذا لم يكن موجوداً نرجع للـ cache فقط.
    // ==========================================================

    final points =
        _parseInt(source['points']) ??
        _parseInt(source['total_points']) ??
        previous?.points ??
        0;

    // ==========================================================
    // WALLET
    // ==========================================================
    //
    // الرصيد الحقيقي من Laravel.
    //
    // الأولوية:
    //
    // wallet
    // wallet_balance
    // balance
    //
    // وإذا لم تصل القيمة في response نستخدم القيمة السابقة
    // الموجودة في cache.
    // ==========================================================

    final walletBalance =
        _parseDouble(source['wallet']) ??
        _parseDouble(source['wallet_balance']) ??
        _parseDouble(source['balance']) ??
        previous?.walletBalance ??
        0.0;

    // ==========================================================
    // BOOKS COUNT
    // ==========================================================

    final booksCount =
        _parseInt(source['books_count']) ??
        _parseInt(source['booksCount']) ??
        previous?.booksCount ??
        0;

    // ==========================================================
    // IMAGE
    // ==========================================================

    final imagePath =
        source['user_image']?.toString() ??
        source['image_path']?.toString() ??
        fallbackImagePath ??
        previous?.imagePath;

    // ==========================================================
    // CREATE MODEL
    // ==========================================================

    return ProfileModel(
      userId: userId,
      name: name,
      email: email,
      points: points,
      booksCount: booksCount,
      walletBalance: walletBalance,
      imagePath: imagePath,
    );
  }

  // ============================================================
  // INT PARSER
  // ============================================================

  int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }

  // ============================================================
  // DOUBLE PARSER
  // ============================================================

  double? _parseDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}
