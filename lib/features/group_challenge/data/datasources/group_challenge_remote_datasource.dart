import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/group_challenge_model.dart';
import '../models/challenge_winner_model.dart';

abstract class GroupChallengeRemoteDataSource {
  Future<GroupChallengeModel?> getActiveChallenge();
  Future<GroupChallengeModel> joinChallenge({required int challengeId});
  Future<List<ChallengeWinnerModel>> getWinners({required int challengeId});
  Future<GroupChallengeModel> incrementBookProgress({required int challengeId});
}

class GroupChallengeRemoteDataSourceImpl
    implements GroupChallengeRemoteDataSource {
  GroupChallengeRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  GroupChallengeModel? _cachedChallenge;

  Future<void> _ensureLoaded() async {
    if (_cachedChallenge != null) return;
    if (useMockData) {
      _cachedChallenge = GroupChallengeModel.fromJson(
        MockDataProvider.activeGroupChallenge(),
      );
      return;
    }
    // TODO: confirm real active-group-challenge endpoint URL with backend team
    // import 'package:dev3/core/network/endpoints.dart' shows Endpoints.activeGroupChallenge
    // final response = await _apiClient.get('/challenges/group/active');
    // if (response.data == null) return;
    // _cachedChallenge = GroupChallengeModel.fromJson(response.data as Map<String, dynamic>);
    _cachedChallenge = GroupChallengeModel.fromJson(
      MockDataProvider.activeGroupChallenge(),
    );
  }

  @override
  Future<GroupChallengeModel?> getActiveChallenge() async {
    await _ensureLoaded();
    return _cachedChallenge;
  }

  @override
  Future<GroupChallengeModel> joinChallenge({
    required int challengeId,
  }) async {
    await _ensureLoaded();
    if (_cachedChallenge != null && _cachedChallenge!.id == challengeId) {
      _cachedChallenge = GroupChallengeModel(
        id: _cachedChallenge!.id,
        title: _cachedChallenge!.title,
        description: _cachedChallenge!.description,
        bonusPoints: _cachedChallenge!.bonusPoints,
        requiredBooks: _cachedChallenge!.requiredBooks,
        requiredQuizzes: _cachedChallenge!.requiredQuizzes,
        deadline: _cachedChallenge!.deadline,
        isJoined: true,
        userBooksCompleted: _cachedChallenge!.userBooksCompleted,
        userQuizzesPassed: _cachedChallenge!.userQuizzesPassed,
        status: _cachedChallenge!.status,
      );
    }
    return _cachedChallenge!;
  }

  @override
  Future<List<ChallengeWinnerModel>> getWinners({
    required int challengeId,
  }) async {
    if (useMockData) {
      final data = MockDataProvider.groupChallengeWinners();
      return data.map((e) => ChallengeWinnerModel.fromJson(e)).toList();
    }
    // TODO: confirm real challenge-winners endpoint URL with backend team
    // import 'package:dev3/core/network/endpoints.dart' shows Endpoints.groupChallengeWinners
    // final response = await _apiClient.get('/challenges/group/$challengeId/winners');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => ChallengeWinnerModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.groupChallengeWinners();
    return data.map((e) => ChallengeWinnerModel.fromJson(e)).toList();
  }

  @override
  Future<GroupChallengeModel> incrementBookProgress({
    required int challengeId,
  }) async {
    await _ensureLoaded();
    // Only increment progress for a challenge the user has actually joined.
    // Caps at the required amount so it never overshoots.
    if (_cachedChallenge != null &&
        _cachedChallenge!.id == challengeId &&
        _cachedChallenge!.isJoined) {
      final newCount =
          (_cachedChallenge!.userBooksCompleted + 1)
              .clamp(0, _cachedChallenge!.requiredBooks);
      _cachedChallenge = GroupChallengeModel(
        id: _cachedChallenge!.id,
        title: _cachedChallenge!.title,
        description: _cachedChallenge!.description,
        bonusPoints: _cachedChallenge!.bonusPoints,
        requiredBooks: _cachedChallenge!.requiredBooks,
        requiredQuizzes: _cachedChallenge!.requiredQuizzes,
        deadline: _cachedChallenge!.deadline,
        isJoined: _cachedChallenge!.isJoined,
        userBooksCompleted: newCount,
        userQuizzesPassed: _cachedChallenge!.userQuizzesPassed,
        status: _cachedChallenge!.status,
      );
    }
    return _cachedChallenge!;
  }
}
