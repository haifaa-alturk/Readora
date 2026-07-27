import 'package:dartz/dartz.dart';

import '../entities/settings_entity.dart';

abstract class SettingsRepositoryInterface {
  Future<Either<String, SettingsEntity>> getSettings();
  Future<Either<String, SettingsEntity>> updateSettings(SettingsEntity settings);
}