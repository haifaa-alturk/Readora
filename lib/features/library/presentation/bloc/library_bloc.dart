import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/library_repository_interface.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepositoryInterface repository;

  LibraryBloc({required this.repository}) : super(const LibraryInitial()) {
    on<LoadLibraryBooksEvent>(_onLoadBooks);
    on<FilterLibraryBooksEvent>(_onFilterBooks);
  }

  Future<void> _onLoadBooks(
    LoadLibraryBooksEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(const LibraryLoading());

    final result = await repository.getUserBooks();
    result.fold(
      (error) => emit(LibraryError(message: error)),
      (books) {
        if (books.isEmpty) {
          emit(const LibraryEmpty());
        } else {
          emit(LibraryLoaded(
            allBooks: books,
            filteredBooks: books,
          ));
        }
      },
    );
  }

  void _onFilterBooks(
    FilterLibraryBooksEvent event,
    Emitter<LibraryState> emit,
  ) {
    final current = state;
    if (current is! LibraryLoaded) return;

    final filtered = event.statusFilter == null
        ? current.allBooks
        : current.allBooks
            .where((b) => b.status == event.statusFilter)
            .toList();

    emit(LibraryLoaded(
      allBooks: current.allBooks,
      filteredBooks: filtered,
      activeFilter: event.statusFilter,
    ));
  }
}