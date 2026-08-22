import 'package:dartz/dartz.dart';

import '../repositories/rating_repository.dart';

class RateBook {
  final RatingRepository repository;

  RateBook(this.repository);

  Future<Either<String, bool>> call({
    required int bookId,
    required int rating,
  }) async {
    return await repository.rateBook(bookId: bookId, rating: rating);
  }
}
