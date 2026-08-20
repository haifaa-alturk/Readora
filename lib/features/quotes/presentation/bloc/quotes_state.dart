import 'package:equatable/equatable.dart';

import '../../domain/entities/quote_entity.dart';

abstract class QuotesState extends Equatable {
  const QuotesState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

class QuotesInitial extends QuotesState {
  const QuotesInitial();
}

// ============================================================
// LOADING
// ============================================================

class QuotesLoading extends QuotesState {
  const QuotesLoading();
}

// ============================================================
// LOADED
// ============================================================

class QuotesLoaded extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuotesLoaded({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}

// ============================================================
// ERROR
// ============================================================

class QuotesError extends QuotesState {
  final String message;

  const QuotesError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================
// DELETE SUCCESS
// ============================================================

class QuoteDeleteSuccess extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuoteDeleteSuccess({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}

// ============================================================
// ADD SUCCESS
// ============================================================

class QuoteAddSuccess extends QuotesState {
  final List<QuoteEntity> quotes;

  const QuoteAddSuccess({required this.quotes});

  @override
  List<Object?> get props => [quotes];
}
