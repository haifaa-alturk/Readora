import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../domain/entities/individual_challenge_entity.dart';
import '../models/individual_challenge_question_model.dart';

class QuizAlreadyAttemptedException implements Exception {
  const QuizAlreadyAttemptedException();
}

class QuizUnavailableException implements Exception {
  const QuizUnavailableException();
}

abstract class IndividualChallengeRemoteDataSource {
  Future<List<IndividualChallengeQuestionModel>> getQuestions({
    required int bookId,
  });

  Future<QuizSubmissionResult> submitQuiz({
    required int bookId,
    required List<Map<String, dynamic>> answers,
  });
}

class IndividualChallengeRemoteDataSourceImpl
    implements IndividualChallengeRemoteDataSource {
  IndividualChallengeRemoteDataSourceImpl(this._realApiClient);

  final ApiClient _realApiClient;

  @override
  Future<List<IndividualChallengeQuestionModel>> getQuestions({
    required int bookId,
  }) async {
    try {
      final response = await _realApiClient.dio.get('user/books/$bookId/quiz');
      final json = Map<String, dynamic>.from(response.data as Map);
      final questions = json['questions'] as List<dynamic>? ?? const [];
      return questions
          .map((e) => IndividualChallengeQuestionModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const QuizAlreadyAttemptedException();
      }
      if (e.response?.statusCode == 404) {
        throw const QuizUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<QuizSubmissionResult> submitQuiz({
    required int bookId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await _realApiClient.dio.post(
        'user/quiz/submit',
        data: {'answers': answers},
      );
      final json = Map<String, dynamic>.from(response.data as Map);
      return QuizSubmissionResult(
        passed: json['passed'] as bool? ?? false,
        correctAnswers: json['correct_answers'] as int? ?? 0,
        pointsEarned: json['points_earned'] as int? ?? 0,
        currentTotalPoints: json['current_total_points'] as int? ?? 0,
        message: json['message'] as String? ?? '',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const QuizAlreadyAttemptedException();
      }
      if (e.response?.statusCode == 404) {
        throw const QuizUnavailableException();
      }
      rethrow;
    }
  }
}