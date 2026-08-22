import 'package:dartz/dartz.dart';

import '../datasources/rating_remote_datasource.dart';
import '../../domain/repositories/rating_repository.dart';

class RatingRepositoryImpl implements RatingRepository {
  final RatingRemoteDataSource remoteDataSource;

  RatingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, bool>> rateBook({
    required int bookId,
    required int rating,
  }) async {
    try {
      await remoteDataSource.rateBook(bookId: bookId, rating: rating);

      return const Right(true);
    } catch (e) {
      print('❌ Rating Error: $e');

      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updateRating({
    required int bookId,
    required int rating,
  }) async {
    try {
      await remoteDataSource.updateRating(bookId: bookId, rating: rating);

      return const Right(true);
    } catch (e) {
      print('❌ Update Rating Error: $e');

      return Left(e.toString());
    }
  }
}
