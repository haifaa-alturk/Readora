import 'package:equatable/equatable.dart';

import '../../domain/entities/interest_entity.dart';

abstract class InterestsState extends Equatable {
  const InterestsState();

  @override
  List<Object?> get props => [];
}

class InterestsInitial extends InterestsState {
  const InterestsInitial();
}

class InterestsLoading extends InterestsState {
  const InterestsLoading();
}

class InterestsLoaded extends InterestsState {
  final List<InterestEntity> interests;

  const InterestsLoaded({required this.interests});

  @override
  List<Object?> get props => [interests];
}

class InterestsSaving extends InterestsState {
  final List<InterestEntity> interests;

  const InterestsSaving({required this.interests});

  @override
  List<Object?> get props => [interests];
}

class InterestsSaveSuccess extends InterestsState {
  final List<InterestEntity> interests;

  const InterestsSaveSuccess({required this.interests});

  @override
  List<Object?> get props => [interests];
}

class InterestsError extends InterestsState {
  final String message;

  const InterestsError({required this.message});

  @override
  List<Object?> get props => [message];
}