import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repositories/book_action_repository.dart';
import '../datasources/book_action_remote_datasource.dart';

class BookActionRepositoryImpl implements BookActionRepository {
  final BookActionRemoteDataSource remoteDataSource;

  BookActionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, bool>> purchaseBook({
    required int bookId,
    required String discountPackage,
  }) async {
    try {
      await remoteDataSource.purchaseBook(
        bookId: bookId,
        discountPackage: discountPackage,
      );

      return const Right(true);
    } on DioException catch (e) {
      print("Failed to purchase book: ${e.response?.data ?? e.message}");

      return Left(
        e.response?.data?.toString() ?? e.message ?? 'Purchase failed',
      );
    } catch (e) {
      print("Failed to purchase book: $e");

      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> borrowBook({
    required int bookId,
    required String discountPackage,
  }) async {
    try {
      await remoteDataSource.borrowBook(
        bookId: bookId,
        discountPackage: discountPackage,
      );

      return const Right(true);
    } on DioException catch (e) {
      print("Failed to borrow book: ${e.response?.data ?? e.message}");

      return Left(e.response?.data?.toString() ?? e.message ?? 'Borrow failed');
    } catch (e) {
      print("Failed to borrow book: $e");

      return Left(e.toString());
    }
  }
}
