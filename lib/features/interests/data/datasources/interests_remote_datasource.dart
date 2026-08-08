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

    return rawList
        .map((e) => InterestModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
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

    final dynamic rawData = json['interests'] ?? [];
    final List rawList = rawData is List ? rawData : [];

    return rawList
        .map((e) => InterestModel(
              id: e is int ? e : int.tryParse('$e') ?? 0,
              name: '',
              isSelected: true,
            ))
        .toList();
  }
}
