import 'package:dartz/dartz.dart';

import '../../domain/entities/individual_challenge_entity.dart';
import '../../domain/repositories/individual_challenge_repository_interface.dart';
import '../datasources/individual_challenge_remote_datasource.dart';
import '../models/individual_challenge_model.dart';

class IndividualChallengeRepositoryImpl
    implements IndividualChallengeRepositoryInterface {
  final IndividualChallengeRemoteDataSource _remoteDataSource;

  IndividualChallengeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, IndividualChallengeEntity>> getChallenge({
    required int bookId,
    required String bookTitle,
  }) async {
    try {
      final result = await _remoteDataSource.getQuestions(bookId: bookId);
      return Right(IndividualChallengeModel(
        bookId: bookId,
        bookTitle: bookTitle,
        questions: result,
      ));
    } catch (e) {
      return Left('Error fetching challenge: ${e.toString()}');
    }
  }
}
