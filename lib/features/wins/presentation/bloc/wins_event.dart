import 'package:equatable/equatable.dart';

import '../../domain/entities/win_entity.dart';

abstract class WinsEvent extends Equatable {
  const WinsEvent();

  @override
  List<Object?> get props => [];
}

class LoadWinsEvent extends WinsEvent {
  const LoadWinsEvent();
}

class RefreshWinsEvent extends WinsEvent {
  const RefreshWinsEvent();
}

class ReceiveNewWinEvent extends WinsEvent {
  final WinEntity win;

  const ReceiveNewWinEvent({required this.win});

  @override
  List<Object?> get props => [win];
}

class RemoveWinEvent extends WinsEvent {
  final int winId;

  const RemoveWinEvent({required this.winId});

  @override
  List<Object?> get props => [winId];
}