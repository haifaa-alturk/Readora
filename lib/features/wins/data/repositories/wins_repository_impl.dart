import 'package:dartz/dartz.dart';

import '../../domain/entities/win_entity.dart';
import '../../domain/repositories/wins_repository_interface.dart';
import '../datasources/wins_remote_datasource.dart';
import '../models/win_model.dart';

class WinsRepositoryImpl implements WinsRepositoryInterface {
  final WinsRemoteDataSource _remoteDataSource;

  WinsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<WinEntity>>> getWins() async {
    try {
      final result = await _remoteDataSource.getWins();
      return Right(result);
    } catch (e) {
      return Left('Error fetching wins: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<WinEntity>>> addWin(WinEntity win) async {
    try {
      final model = WinModel(
        id: win.id,
        title: win.title,
        description: win.description,
        iconName: win.iconName,
        dateEarned: win.dateEarned,
        type: win.type,
        rank: win.rank,
        eventName: win.eventName,
        challengeId: win.challengeId,
        challengeType: win.challengeType,
        reward: win.reward,
        earnedPoints: win.earnedPoints,
        completedDate: win.completedDate,
        certificateImage: win.certificateImage,
        status: win.status,
      );
      final result = await _remoteDataSource.addWin(model);
      return Right(result);
    } catch (e) {
      return Left('Error adding win: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<WinEntity>>> removeWin(int winId) async {
    try {
      final result = await _remoteDataSource.removeWin(winId);
      return Right(result);
    } catch (e) {
      return Left('Error removing win: ${e.toString()}');
    }
  }
}