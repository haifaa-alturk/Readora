import 'package:dartz/dartz.dart';

import '../entities/interest_entity.dart';

abstract class InterestsRepositoryInterface {
  Future<Either<String, List<InterestEntity>>> getAllInterests();
  Future<Either<String, List<InterestEntity>>> updateUserInterests(
      List<int> selectedInterestIds);
}