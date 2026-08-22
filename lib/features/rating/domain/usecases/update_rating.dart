import 'package:dartz/dartz.dart';

import '../repositories/rating_repository.dart';

class UpdateRating {
  final RatingRepository repository;

  UpdateRating(this.repository);

  Future<Either<String, bool>> call({
    required int bookId,
    required int rating,
  }) async {
    return await repository.updateRating(bookId: bookId, rating: rating);
  }
}
