import '../../domain/entities/book_details.dart';

abstract class BookDetailsState {}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final BookDetails book;
  final bool hasAccess;

  BookDetailsLoaded(this.book, this.hasAccess);
}

class BookDetailsError extends BookDetailsState {
  final String message;

  BookDetailsError(this.message);
}

// ==========================================
// Purchase Loading
// ==========================================

class BookDetailsPurchaseLoading extends BookDetailsState {
  final BookDetails book;

  BookDetailsPurchaseLoading(this.book);
}

// ==========================================
// Borrow Loading
// ==========================================

class BookDetailsBorrowLoading extends BookDetailsState {
  final BookDetails book;

  BookDetailsBorrowLoading(this.book);
}

// ==========================================
// Action Error
// ==========================================

class BookDetailsActionError extends BookDetailsState {
  final BookDetails book;
  final bool hasAccess;
  final String message;

  BookDetailsActionError(this.book, this.hasAccess, this.message);
}
