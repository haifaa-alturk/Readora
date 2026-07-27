import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/quotes_repository_interface.dart';
import 'quotes_event.dart';
import 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  final QuotesRepositoryInterface _repository;

  QuotesBloc({required QuotesRepositoryInterface repository})
      : _repository = repository,
        super(const QuotesInitial()) {
    on<LoadQuotesEvent>(_onLoadQuotes);
    on<DeleteQuoteEvent>(_onDeleteQuote);
    on<AddQuoteEvent>(_onAddQuote);
  }

  Future<void> _onLoadQuotes(
    LoadQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    emit(const QuotesLoading());
    final result = await _repository.getQuotes();
    result.fold(
      (error) => emit(QuotesError(message: error)),
      (quotes) => emit(QuotesLoaded(quotes: quotes)),
    );
  }

  Future<void> _onDeleteQuote(
    DeleteQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! QuotesLoaded) return;

    final result = await _repository.deleteQuote(event.quoteId);
    result.fold(
      (error) => emit(QuotesError(message: error)),
      (success) {
        final updatedQuotes = currentState.quotes
            .where((quote) => quote.id != event.quoteId)
            .toList();
        emit(QuoteDeleteSuccess(quotes: updatedQuotes));
      },
    );
  }

  Future<void> _onAddQuote(
    AddQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! QuotesLoaded) return;

    final result = await _repository.addQuote(
      bookId: event.bookId,
      quoteText: event.quoteText,
    );
    result.fold(
      (error) => emit(QuotesError(message: error)),
      (newQuote) {
        final updatedQuotes = [newQuote, ...currentState.quotes];
        emit(QuoteAddSuccess(quotes: updatedQuotes));
      },
    );
  }
}