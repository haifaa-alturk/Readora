import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Book> recommendedBooks;
  final List<Book> topRatedBooks;
  final List<Book> newBooks;

  HomeLoaded({
    required this.recommendedBooks,
    required this.topRatedBooks,
    required this.newBooks,
  });

  @override
  List<Object?> get props => [recommendedBooks, topRatedBooks, newBooks];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}