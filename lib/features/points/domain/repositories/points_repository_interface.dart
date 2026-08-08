import 'package:dartz/dartz.dart';

import '../entities/points_history_entry_entity.dart';

abstract class PointsRepositoryInterface {
  Future<Either<String, int>> getTotalPoints();
  Future<Either<String, List<PointsHistoryEntryEntity>>> getPointsHistory();
  Future<Either<String, List<PointsHistoryEntryEntity>>> addPoints({required int amount, required String source});
}