import 'package:dartz/dartz.dart';

import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository_interface.dart';
import '../datasources/quotes_remote_datasource.dart';

class QuotesRepositoryImpl implements QuotesRepositoryInterface {
  final QuotesRemoteDataSource _dataSource;

  QuotesRepositoryImpl(this._dataSource);

  // ============================================================
  // GET QUOTES
  // ============================================================

  @override
  Future<Either<String, List<QuoteEntity>>> getQuotes() async {
    try {
      final quotes = await _dataSource.getQuotes();

      return Right(quotes);
    } catch (e) {
      return Left('Error loading quotes: ${e.toString()}');
    }
  }

  // ============================================================
  // DELETE QUOTE
  // ============================================================

  @override
  Future<Either<String, bool>> deleteQuote(int quoteId) async {
    try {
      final success = await _dataSource.deleteQuote(quoteId);

      if (!success) {
        return const Left('Failed to delete quote.');
      }

      return const Right(true);
    } catch (e) {
      return Left('Error deleting quote: ${e.toString()}');
    }
  }

  // ============================================================
  // ADD QUOTE
  // ============================================================

  @override
  Future<Either<String, QuoteEntity>> addQuote({
    required int bookId,
    required String quoteText,
    String bookTitle = '',
  }) async {
    try {
      final quote = await _dataSource.addQuote(
        bookId: bookId,
        quoteText: quoteText,
        bookTitle: bookTitle,
      );

      return Right(quote);
    } catch (e) {
      return Left('Error saving quote: ${e.toString()}');
    }
  }
}
