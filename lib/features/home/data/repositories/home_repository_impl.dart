import 'package:dartz/dartz.dart';
// تأكدي أن هذا المسار يطابق مكان ملف الـ Entity (الكتاب)
import '../../domain/entities/book.dart'; 
import '../../domain/repositories/home_repository.dart';
// تأكدي أن اسم الملف هنا يطابق تماماً ما هو موجود في المجلد
import '../datasources/home_remote_datasource.dart'; 

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Book>>> getRecommendedBooks() async {
    try {
      final result = await remoteDataSource.getRecommendedBooks();
      return Right(result);
    } catch (e) {
      return Left("فشل تحميل الاقتراحات: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<Book>>> getTopRatedBooks() async {
    try {
      final result = await remoteDataSource.getTopRatedBooks();
      return Right(result);
    } catch (e) {
      return Left("فشل تحميل الكتب الأعلى تقييماً: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, List<Book>>> getNewBooks() async {
    try {
      final result = await remoteDataSource.getNewBooks();
      return Right(result);
    } catch (e) {
      return Left("فشل تحميل الكتب الجديدة: ${e.toString()}");
    }
  }
}