import 'package:equatable/equatable.dart';

import '../../domain/entities/library_book_entity.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {
  const LibraryInitial();
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();
}

class LibraryLoaded extends LibraryState {
  final List<LibraryBookEntity> allBooks;
  final List<LibraryBookEntity> filteredBooks;
  final String? activeFilter;

  const LibraryLoaded({
    required this.allBooks,
    required this.filteredBooks,
    this.activeFilter,
  });

  @override
  List<Object?> get props => [allBooks, filteredBooks, activeFilter];
}

class LibraryEmpty extends LibraryState {
  const LibraryEmpty();
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError({required this.message});

  @override
  List<Object?> get props => [message];
}