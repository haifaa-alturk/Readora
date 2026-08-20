import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/quote_entity.dart';
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
    final currentQuotes = _getCurrentQuotes();

    final result = await _repository.deleteQuote(event.quoteId);

    result.fold((error) => emit(QuotesError(message: error)), (success) {
      if (!success) {
        emit(const QuotesError(message: 'Failed to delete quote.'));
        return;
      }

      final updatedQuotes = currentQuotes
          .where((quote) => quote.id != event.quoteId)
          .toList();

      emit(QuoteDeleteSuccess(quotes: updatedQuotes));
    });
  }

  Future<void> _onAddQuote(
    AddQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    final currentQuotes = _getCurrentQuotes();

    final alreadyExists = currentQuotes.any(
      (quote) =>
          quote.bookId == event.bookId &&
          quote.quoteText.trim() == event.quoteText.trim(),
    );

    if (alreadyExists) {
      emit(QuoteAddSuccess(quotes: currentQuotes));
      return;
    }

    final result = await _repository.addQuote(
      bookId: event.bookId,
      quoteText: event.quoteText.trim(),
    );

    result.fold((error) => emit(QuotesError(message: error)), (newQuote) {
      final updatedQuotes = [newQuote, ...currentQuotes];

      emit(QuoteAddSuccess(quotes: updatedQuotes));
    });
  }

  List<QuoteEntity> _getCurrentQuotes() {
    if (state is QuotesLoaded) {
      return (state as QuotesLoaded).quotes;
    }

    if (state is QuoteAddSuccess) {
      return (state as QuoteAddSuccess).quotes;
    }

    if (state is QuoteDeleteSuccess) {
      return (state as QuoteDeleteSuccess).quotes;
    }

    return [];
  }
}
