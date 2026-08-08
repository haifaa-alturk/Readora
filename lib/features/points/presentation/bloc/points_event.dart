import 'package:equatable/equatable.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPointsEvent extends PointsEvent {
  const LoadPointsEvent();
}

class AddPointsEvent extends PointsEvent {
  final int amount;
  final String source;

  const AddPointsEvent({required this.amount, required this.source});

  @override
  List<Object?> get props => [amount, source];
}