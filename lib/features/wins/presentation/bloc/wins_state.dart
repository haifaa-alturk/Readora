import 'package:equatable/equatable.dart';

import '../../domain/entities/win_entity.dart';

abstract class WinsState extends Equatable {
  const WinsState();

  @override
  List<Object?> get props => [];
}

class WinsInitial extends WinsState {
  const WinsInitial();
}

class WinsLoading extends WinsState {
  const WinsLoading();
}

class WinsRefreshing extends WinsState {
  final List<WinEntity> currentWins;

  const WinsRefreshing({required this.currentWins});

  @override
  List<Object?> get props => [currentWins];
}

class WinsLoaded extends WinsState {
  final List<WinEntity> wins;

  const WinsLoaded({required this.wins});

  @override
  List<Object?> get props => [wins];
}

class WinsEmpty extends WinsState {
  const WinsEmpty();
}

class WinsError extends WinsState {
  final String message;

  const WinsError({required this.message});

  @override
  List<Object?> get props => [message];
}