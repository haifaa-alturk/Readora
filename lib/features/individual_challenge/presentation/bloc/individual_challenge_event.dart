import 'package:equatable/equatable.dart';

abstract class IndividualChallengeEvent extends Equatable {
  const IndividualChallengeEvent();

  @override
  List<Object?> get props => [];
}

class LoadIndividualChallengeEvent extends IndividualChallengeEvent {
  final int bookId;
  final String bookTitle;

  const LoadIndividualChallengeEvent({
    required this.bookId,
    required this.bookTitle,
  });

  @override
  List<Object?> get props => [bookId, bookTitle];
}

class AnswerQuestionEvent extends IndividualChallengeEvent {
  final int questionIndex;
  final int selectedOptionIndex;

  const AnswerQuestionEvent({
    required this.questionIndex,
    required this.selectedOptionIndex,
  });

  @override
  List<Object?> get props => [questionIndex, selectedOptionIndex];
}

class SkipChallengeEvent extends IndividualChallengeEvent {
  const SkipChallengeEvent();
}
