import 'package:equatable/equatable.dart';

abstract class QuotesEvent extends Equatable {
  const QuotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuotesEvent extends QuotesEvent {
  const LoadQuotesEvent();
}

class DeleteQuoteEvent extends QuotesEvent {
  final int quoteId;

  const DeleteQuoteEvent({required this.quoteId});

  @override
  List<Object?> get props => [quoteId];
}

class AddQuoteEvent extends QuotesEvent {
  final int bookId;
  final String quoteText;

  const AddQuoteEvent({required this.bookId, required this.quoteText});

  @override
  List<Object?> get props => [bookId, quoteText];
}