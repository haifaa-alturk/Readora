import '../../domain/entities/book_details.dart';

abstract class BookDetailsState {}

class BookDetailsInitial extends BookDetailsState {}

class BookDetailsLoading extends BookDetailsState {}

class BookDetailsLoaded extends BookDetailsState {
  final BookDetails book;

  BookDetailsLoaded(this.book);
}

class BookDetailsError extends BookDetailsState {
  final String message;

  BookDetailsError(this.message);
}
