import 'package:dartz/dartz.dart'; // لمناولة الأخطاء بشكل احترافي
import '../entities/book.dart';

abstract class HomeRepository {
  Future<Either<String, List<Book>>> getRecommendedBooks();
  Future<Either<String, List<Book>>> getTopRatedBooks();
  Future<Either<String, List<Book>>> getNewBooks();
}