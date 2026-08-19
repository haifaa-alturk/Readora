import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/points_history_entry_entity.dart';
import '../../domain/repositories/points_repository_interface.dart';
import 'points_event.dart';
import 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final PointsRepositoryInterface repository;

  PointsBloc({required this.repository}) : super(const PointsInitial()) {
    on<LoadPointsEvent>(_onLoadPoints);
    on<AddPointsEvent>(_onAddPoints);
  }

  Future<void> _onLoadPoints(
    LoadPointsEvent event,
    Emitter<PointsState> emit,
  ) async {
    emit(const PointsLoading());

    final totalResult = await repository.getTotalPoints();
    final historyResult = await repository.getPointsHistory();

    totalResult.fold(
      (error) => emit(PointsError(message: error)),
      (total) {
        historyResult.fold(
          (error) => emit(PointsError(message: error)),
          (history) => emit(PointsLoaded(totalPoints: total, history: history)),
        );
      },
    );
  }

  Future<void> _onAddPoints(
    AddPointsEvent event,
    Emitter<PointsState> emit,
  ) async {
    emit(const PointsLoading());

    final refreshResult = await repository.addPoints(
      amount: event.amount,
      source: event.source,
    );

    List<PointsHistoryEntryEntity>? history;
    refreshResult.fold(
      (error) => emit(PointsError(message: error)),
      (h) => history = h,
    );
    if (history == null) return;

    final totalResult = await repository.getTotalPoints();
    totalResult.fold(
      (error) => emit(PointsError(message: error)),
      (total) => emit(PointsLoaded(totalPoints: total, history: history!)),
    );
  }
}