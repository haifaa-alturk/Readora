import 'package:flutter_bloc/flutter_bloc.dart';

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
    final current = state;
    if (current is! PointsLoaded) return;

    emit(PointsLoading());

    final result = await repository.addPoints(
      amount: event.amount,
      source: event.source,
    );

    result.fold(
      (error) => emit(PointsError(message: error)),
      (history) {
        final newTotal = current.totalPoints + event.amount;
        emit(PointsLoaded(totalPoints: newTotal, history: history));
      },
    );
  }
}