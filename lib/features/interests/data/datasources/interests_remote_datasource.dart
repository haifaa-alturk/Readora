import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/interest_model.dart';

abstract class InterestsRemoteDataSource {
  Future<List<InterestModel>> getAllInterests();
  Future<List<InterestModel>> updateUserInterests(List<int> selectedInterestIds);
}

class InterestsRemoteDataSourceImpl implements InterestsRemoteDataSource {
  InterestsRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  @override
  Future<List<InterestModel>> getAllInterests() async {
    if (useMockData) {
      final data = MockDataProvider.interests();
      return data.map((e) => InterestModel.fromJson(e)).toList();
    }
    // TODO: confirm real interests endpoints with backend team
    // final response = await _apiClient.get('/interests');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.interests();
    return data.map((e) => InterestModel.fromJson(e)).toList();
  }

  @override
  Future<List<InterestModel>> updateUserInterests(
      List<int> selectedInterestIds) async {
    if (useMockData) {
      final all = MockDataProvider.interests();
      final updated = all.map((e) {
        final isSelected = selectedInterestIds.contains(e['id'] as int);
        return <String, dynamic>{
          ...e,
          'is_selected': isSelected,
        };
      }).toList();
      return updated.map((e) => InterestModel.fromJson(e)).toList();
    }
    // TODO: confirm real interests endpoints with backend team
    // final response = await _apiClient.put(
    //   '/profile/interests',
    //   data: {'interest_ids': selectedInterestIds},
    // );
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => InterestModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final all = MockDataProvider.interests();
    final updated = all.map((e) {
      final isSelected = selectedInterestIds.contains(e['id'] as int);
      return <String, dynamic>{
        ...e,
        'is_selected': isSelected,
      };
    }).toList();
    return updated.map((e) => InterestModel.fromJson(e)).toList();
  }
}