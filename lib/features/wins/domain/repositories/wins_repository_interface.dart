import 'package:dartz/dartz.dart';

import '../entities/win_entity.dart';

abstract class WinsRepositoryInterface {
  Future<Either<String, List<WinEntity>>> getWins();
  Future<Either<String, List<WinEntity>>> addWin(WinEntity win);
  Future<Either<String, List<WinEntity>>> removeWin(int winId);
}