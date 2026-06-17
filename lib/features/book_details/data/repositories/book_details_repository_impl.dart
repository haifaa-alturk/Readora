import 'package:dartz/dartz.dart';

import '../../domain/entities/book_details.dart';

import '../../domain/repositories/book_details_repository.dart';

import '../datasources/book_details_remote_datasource.dart';

class BookDetailsRepositoryImpl implements BookDetailsRepository {
  final BookDetailsRemoteDataSource remoteDataSource;

  BookDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, BookDetails>> getBookDetails(int id) async {
    try {
      final result = await remoteDataSource.getBookDetails(id);

      return Right(result);
    } catch (e) {
      return Left("فشل تحميل تفاصيل الكتاب");
    }
  }
}
