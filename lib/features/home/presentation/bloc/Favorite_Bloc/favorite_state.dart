import 'package:library_app1/features/home/domain/entities/book.dart';



abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Book> favoriteBooks;
  FavoriteLoaded(this.favoriteBooks);
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}