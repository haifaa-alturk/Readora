import 'package:dartz/dartz.dart';

import '../../domain/entities/points_history_entry_entity.dart';
import '../../domain/repositories/points_repository_interface.dart';
import '../datasources/points_remote_datasource.dart';

class PointsRepositoryImpl implements PointsRepositoryInterface {
  final PointsRemoteDataSource _remoteDataSource;

  PointsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, int>> getTotalPoints() async {
    try {
      final result = await _remoteDataSource.getTotalPoints();
      return Right(result);
    } catch (e) {
      return Left('Error fetching total points: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<PointsHistoryEntryEntity>>>
      getPointsHistory() async {
    try {
      final result = await _remoteDataSource.getPointsHistory();
      return Right(result);
    } catch (e) {
      return Left('Error fetching points history: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<PointsHistoryEntryEntity>>> addPoints({
    required int amount,
    required String source,
  }) async {
    try {
      final result = await _remoteDataSource.addPoints(
        amount: amount,
        source: source,
      );
      return Right(result);
    } catch (e) {
      return Left('Error adding points: ${e.toString()}');
    }
  }
}