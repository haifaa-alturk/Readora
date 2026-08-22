import 'package:equatable/equatable.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================
// LOAD
// ============================================================

class LoadQuotesEvent extends QuotesEvent {
  const LoadQuotesEvent();
}

// ============================================================
// DELETE
// ============================================================

class DeleteQuoteEvent extends QuotesEvent {
  final int quoteId;

  const DeleteQuoteEvent({required this.quoteId});

  @override
  List<Object?> get props => [quoteId];
}

// ============================================================
// ADD
// ============================================================

class AddQuoteEvent extends QuotesEvent {
  final int bookId;

  final String quoteText;

  final String bookTitle;

  const AddQuoteEvent({
    required this.bookId,
    required this.quoteText,
    this.bookTitle = '',
  });

  @override
  List<Object?> get props => [bookId, quoteText, bookTitle];
}
