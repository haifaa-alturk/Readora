import 'package:dio/dio.dart';
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/core/mock_dev3/mock_config.dart';

import '../models/interest_model.dart';

abstract class InterestsRemoteDataSource {
  Future<List<InterestModel>> getAllInterests();
  Future<List<InterestModel>> updateUserInterests(List<int> selectedInterestIds);
}

class InterestsRemoteDataSourceImpl implements InterestsRemoteDataSource {
  InterestsRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<InterestModel>> getAllInterests() async {
    print("Interests: useMockData=$useMockData");
    print("Interests: calling GET categories...");
    final response = await _apiClient.dio.get('categories');
    print("Interests: GET response status=${response.statusCode}");

    final dynamic rawData = response.data;
    List rawList;

    if (rawData is List && rawData.isNotEmpty && rawData.first is List) {
      rawList = rawData.first;
    } else if (rawData is List) {
      rawList = rawData;
    } else {
      rawList = rawData['data'] ?? [];
    }

    final interests = rawList
        .map((e) => InterestModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    final selectedIds = await _fetchUserCategoryIds();

    return interests
        .map((i) => i.copyWithSelected(isSelected: selectedIds.contains(i.id)))
        .toList();
  }

  Future<Set<int>> _fetchUserCategoryIds() async {
    try {
      print("Interests: calling GET user to load saved categories...");
      final userResponse = await _apiClient.dio.get('user');
      final dynamic userData = userResponse.data;
      final dynamic categories = userData is Map<String, dynamic>
          ? userData['categories']
          : null;

      if (categories is List) {
        return categories
            .map((e) => e is Map<String, dynamic>
                ? int.tryParse('${e['id']}')
                : int.tryParse('$e'))
            .whereType<int>()
            .toSet();
      }
    } catch (e) {
      print("Interests: could not load saved categories: $e");
    }
    return <int>{};
  }

  @override
  Future<List<InterestModel>> updateUserInterests(
      List<int> selectedInterestIds) async {
    print(
        "Interests: calling POST profile_update with interests=$selectedInterestIds...");
    final response = await _apiClient.dio.post(
      'profile_update',
      data: FormData.fromMap({
        'interests[]': selectedInterestIds,
      }),
    );
    print("Interests: POST response status=${response.statusCode}");

    final json = (response.data as Map<String, dynamic>)['user']
        as Map<String, dynamic>;

    final dynamic rawData = json['categories'] ?? [];
    final List rawList = rawData is List ? rawData : [];

    return rawList
        .map((e) => e is Map<String, dynamic>
            ? InterestModel.fromJson({
                ...e,
                'is_selected': true,
              })
            : InterestModel(
                id: e is int ? e : int.tryParse('$e') ?? 0,
                name: '',
                isSelected: true,
              ))
        .toList();
  }
}
