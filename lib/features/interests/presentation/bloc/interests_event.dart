import 'package:equatable/equatable.dart';

abstract class InterestsEvent extends Equatable {
  const InterestsEvent();

  @override
  List<Object?> get props => [];
}

class LoadInterestsEvent extends InterestsEvent {
  const LoadInterestsEvent();
}

class ToggleInterestEvent extends InterestsEvent {
  final int interestId;

  const ToggleInterestEvent({required this.interestId});

  @override
  List<Object?> get props => [interestId];
}

class SaveInterestsEvent extends InterestsEvent {
  final List<int> selectedInterestIds;

  const SaveInterestsEvent({required this.selectedInterestIds});

  @override
  List<Object?> get props => [selectedInterestIds];
}