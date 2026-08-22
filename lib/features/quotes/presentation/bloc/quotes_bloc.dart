import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository_interface.dart';
import 'quotes_event.dart';
import 'quotes_state.dart';

class QuotesBloc extends Bloc<QuotesEvent, QuotesState> {
  final QuotesRepositoryInterface repository;

  QuotesBloc({required this.repository}) : super(const QuotesInitial()) {
    on<LoadQuotesEvent>(_onLoadQuotes);
    on<DeleteQuoteEvent>(_onDeleteQuote);
    on<AddQuoteEvent>(_onAddQuote);
  }

  // ============================================================
  // LOAD QUOTES
  // ============================================================

  Future<void> _onLoadQuotes(
    LoadQuotesEvent event,
    Emitter<QuotesState> emit,
  ) async {
    emit(const QuotesLoading());

    try {
      final result = await repository.getQuotes();

      result.fold(
        (error) {
          emit(QuotesError(message: error));
        },
        (quotes) {
          emit(QuotesLoaded(quotes: quotes));
        },
      );
    } catch (e) {
      emit(QuotesError(message: 'Error loading quotes: $e'));
    }
  }

  // ============================================================
  // ADD QUOTE
  // ============================================================

  Future<void> _onAddQuote(
    AddQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    final text = event.quoteText.trim();

    if (text.isEmpty) {
      emit(const QuotesError(message: 'Quote cannot be empty.'));
      return;
    }

    try {
      debugPrint('======================================');
      debugPrint('QUOTES BLOC - ADD QUOTE');
      debugPrint('BOOK ID: ${event.bookId}');
      debugPrint('BOOK TITLE: ${event.bookTitle}');
      debugPrint('TEXT: $text');
      debugPrint('======================================');

      final result = await repository.addQuote(
        bookId: event.bookId,
        quoteText: text,
        bookTitle: event.bookTitle,
      );

      // ----------------------------------------------------------
      // CHECK ADD RESULT
      // ----------------------------------------------------------

      String? errorMessage;
      QuoteEntity? addedQuote;

      result.fold(
        (error) {
          errorMessage = error;
        },
        (quote) {
          addedQuote = quote;
        },
      );

      if (errorMessage != null) {
        debugPrint('❌ QUOTE ADD ERROR: $errorMessage');

        emit(QuotesError(message: errorMessage!));

        return;
      }

      if (addedQuote == null) {
        emit(const QuotesError(message: 'Quote was not saved.'));

        return;
      }

      debugPrint('✅ QUOTE SAVED: ${addedQuote!.quoteText}');

      // ----------------------------------------------------------
      // RELOAD QUOTES
      // ----------------------------------------------------------

      final quotesResult = await repository.getQuotes();

      String? reloadError;
      List<QuoteEntity> quotes = [];

      quotesResult.fold(
        (error) {
          reloadError = error;
        },
        (loadedQuotes) {
          quotes = loadedQuotes;
        },
      );

      if (reloadError != null) {
        debugPrint('❌ QUOTES RELOAD ERROR: $reloadError');

        emit(QuotesError(message: reloadError!));

        return;
      }

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      debugPrint('✅ QUOTES RELOADED: ${quotes.length}');

      emit(QuoteAddSuccess(quotes: quotes));
    } catch (e) {
      debugPrint('❌ ADD QUOTE EXCEPTION: $e');

      emit(QuotesError(message: 'Error saving quote: $e'));
    }
  }

  // ============================================================
  // DELETE QUOTE
  // ============================================================

  Future<void> _onDeleteQuote(
    DeleteQuoteEvent event,
    Emitter<QuotesState> emit,
  ) async {
    try {
      final result = await repository.deleteQuote(event.quoteId);

      String? errorMessage;
      bool deleted = false;

      result.fold(
        (error) {
          errorMessage = error;
        },
        (success) {
          deleted = success;
        },
      );

      if (errorMessage != null) {
        emit(QuotesError(message: errorMessage!));

        return;
      }

      if (!deleted) {
        emit(const QuotesError(message: 'Failed to delete quote.'));

        return;
      }

      // ----------------------------------------------------------
      // RELOAD AFTER DELETE
      // ----------------------------------------------------------

      final quotesResult = await repository.getQuotes();

      String? reloadError;
      List<QuoteEntity> quotes = [];

      quotesResult.fold(
        (error) {
          reloadError = error;
        },
        (loadedQuotes) {
          quotes = loadedQuotes;
        },
      );

      if (reloadError != null) {
        emit(QuotesError(message: reloadError!));

        return;
      }

      emit(QuoteDeleteSuccess(quotes: quotes));
    } catch (e) {
      emit(QuotesError(message: 'Error deleting quote: $e'));
    }
  }
}
