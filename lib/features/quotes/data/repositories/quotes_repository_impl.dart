import 'package:dartz/dartz.dart';

import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository_interface.dart';
import '../datasources/quotes_remote_datasource.dart';

class QuotesRepositoryImpl implements QuotesRepositoryInterface {
  final QuotesRemoteDataSource _remoteDataSource;

  QuotesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<QuoteEntity>>> getQuotes() async {
    try {
      final result = await _remoteDataSource.getQuotes();
      return Right(result);
    } catch (e) {
      return Left('Error fetching quotes: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, bool>> deleteQuote(int quoteId) async {
    try {
      final result = await _remoteDataSource.deleteQuote(quoteId);
      return Right(result);
    } catch (e) {
      return Left('Error deleting quote: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, QuoteEntity>> addQuote({required int bookId, required String quoteText}) async {
    try {
      final result = await _remoteDataSource.addQuote(
        bookId: bookId,
        quoteText: quoteText,
      );
      return Right(result);
    } catch (e) {
      return Left('Error adding quote: ${e.toString()}');
    }
  }
}