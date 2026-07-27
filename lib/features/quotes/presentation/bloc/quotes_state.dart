import 'package:equatable/equatable.dart';

import '../../domain/entities/quote_entity.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object?> get props => [];
}

class QuotesInitial extends QuotesState {
  const QuotesInitial();
}

class QuotesLoading extends QuotesState {
  const QuotesLoading();
}

class QuotesLoaded extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuotesLoaded({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}

class QuotesError extends QuotesState {
  final String message;

  const QuotesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class QuoteDeleteSuccess extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuoteDeleteSuccess({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}

class QuoteAddSuccess extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuoteAddSuccess({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}