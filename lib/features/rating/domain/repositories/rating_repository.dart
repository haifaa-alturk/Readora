import 'package:dartz/dartz.dart';

abstract class RatingRepository {
  Future<Either<String, bool>> rateBook({
    required int bookId,
    required int rating,
  });

  Future<Either<String, bool>> updateRating({
    required int bookId,
    required int rating,
  });
}
