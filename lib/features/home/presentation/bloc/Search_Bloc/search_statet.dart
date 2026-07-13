import 'package:equatable/equatable.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<Book> books;

  const SearchSuccess({required this.books});

  @override
  List<Object?> get props => [books];
}

class SearchFailure extends SearchState {
  final String errorMessage;

  const SearchFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}