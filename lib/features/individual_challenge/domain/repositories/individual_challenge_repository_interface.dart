import 'package:dartz/dartz.dart';

import '../entities/individual_challenge_entity.dart';

abstract class IndividualChallengeRepositoryInterface {
  Future<Either<String, IndividualChallengeEntity>> getChallenge({
    required int bookId,
    required String bookTitle,
  });
}