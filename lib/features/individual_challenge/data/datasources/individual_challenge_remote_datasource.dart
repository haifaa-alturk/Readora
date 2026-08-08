import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/individual_challenge_question_model.dart';

abstract class IndividualChallengeRemoteDataSource {
  Future<List<IndividualChallengeQuestionModel>> getQuestions({
    required int bookId,
  });
}

class IndividualChallengeRemoteDataSourceImpl
    implements IndividualChallengeRemoteDataSource {
  IndividualChallengeRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  @override
  Future<List<IndividualChallengeQuestionModel>> getQuestions({
    required int bookId,
  }) async {
    if (useMockData) {
      final data = MockDataProvider.individualChallengeQuestions(bookId);
      return data.map((e) => IndividualChallengeQuestionModel.fromJson(e)).toList();
    }
    // TODO: confirm real challenge-questions endpoint URL with backend team
    // import 'package:dev3/core/network/endpoints.dart' shows Endpoints.individualChallengeQuestions
    // final response = await _apiClient.get('/books/$bookId/challenge-questions');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => IndividualChallengeQuestionModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.individualChallengeQuestions(bookId);
    return data.map((e) => IndividualChallengeQuestionModel.fromJson(e)).toList();
  }
}
