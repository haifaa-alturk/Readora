import 'package:dartz/dartz.dart';

import '../entities/quote_entity.dart';

abstract class QuotesRepositoryInterface {
  Future<Either<String, List<QuoteEntity>>> getQuotes();

  Future<Either<String, bool>> deleteQuote(int quoteId);

  Future<Either<String, QuoteEntity>> addQuote({
    required int bookId,
    required String quoteText,
    String bookTitle,
  });
}
