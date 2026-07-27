import 'package:equatable/equatable.dart';

import '../../domain/entities/points_history_entry_entity.dart';

abstract class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object?> get props => [];
}

class PointsInitial extends PointsState {
  const PointsInitial();
}

class PointsLoading extends PointsState {
  const PointsLoading();
}

class PointsLoaded extends PointsState {
  final int totalPoints;
  final List<PointsHistoryEntryEntity> history;

  const PointsLoaded({
    required this.totalPoints,
    required this.history,
  });

  @override
  List<Object?> get props => [totalPoints, history];
}

class PointsError extends PointsState {
  final String message;

  const PointsError({required this.message});

  @override
  List<Object?> get props => [message];
}