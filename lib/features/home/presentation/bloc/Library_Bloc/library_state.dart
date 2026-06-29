import 'package:library_app1/features/home/data/models/book_model.dart';


abstract class LibraryState {}

class LibraryInitial extends LibraryState {}
class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<BookModel> books;
  LibraryLoaded({required this.books});
}

class LibraryError extends LibraryState {
  final String message;
  LibraryError({required this.message});
}