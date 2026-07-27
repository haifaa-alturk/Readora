import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/win_entity.dart';
import '../../domain/repositories/wins_repository_interface.dart';
import 'wins_event.dart';
import 'wins_state.dart';

class WinsBloc extends Bloc<WinsEvent, WinsState> {
  final WinsRepositoryInterface repository;

  WinsBloc({required this.repository}) : super(const WinsInitial()) {
    on<LoadWinsEvent>(_onLoadWins);
    on<RefreshWinsEvent>(_onRefreshWins);
    on<ReceiveNewWinEvent>(_onReceiveNewWin);
    on<RemoveWinEvent>(_onRemoveWin);
  }

  Future<void> _onLoadWins(
    LoadWinsEvent event,
    Emitter<WinsState> emit,
  ) async {
    emit(const WinsLoading());

    final result = await repository.getWins();
    result.fold(
      (error) => emit(WinsError(message: error)),
      (wins) {
        if (wins.isEmpty) {
          emit(const WinsEmpty());
        } else {
          emit(WinsLoaded(wins: wins));
        }
      },
    );
  }

  Future<void> _onRefreshWins(
    RefreshWinsEvent event,
    Emitter<WinsState> emit,
  ) async {
    final current = state;
    if (current is! WinsLoaded) return;

    emit(WinsRefreshing(currentWins: current.wins));

    final result = await repository.getWins();
    result.fold(
      (error) => emit(WinsError(message: error)),
      (wins) =>
          wins.isEmpty ? emit(const WinsEmpty()) : emit(WinsLoaded(wins: wins)),
    );
  }

  Future<void> _onReceiveNewWin(
    ReceiveNewWinEvent event,
    Emitter<WinsState> emit,
  ) async {
    final result = await repository.addWin(event.win);
    result.fold(
      (error) => emit(WinsError(message: error)),
      (updatedWins) => emit(WinsLoaded(wins: updatedWins)),
    );
  }

  Future<void> _onRemoveWin(
    RemoveWinEvent event,
    Emitter<WinsState> emit,
  ) async {
    final current = state;
    if (current is! WinsLoaded) return;

    emit(WinsRefreshing(currentWins: current.wins));

    final result = await repository.removeWin(event.winId);
    result.fold(
      (error) => emit(WinsError(message: error)),
      (wins) {
        if (wins.isEmpty) {
          emit(const WinsEmpty());
        } else {
          emit(WinsLoaded(wins: wins));
        }
      },
    );
  }
}