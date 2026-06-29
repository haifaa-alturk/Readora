import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/data/datasources/LibraryRemoteDataSource.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRemoteDataSource dataSource;

  LibraryBloc({required this.dataSource}) : super(LibraryInitial()) {
    on<FetchAllBooks>((event, emit) async {
      emit(LibraryLoading());
      try {
        final books = await dataSource.getAllBooks();
        emit(LibraryLoaded(books: books));
      } catch (e) {
        emit(LibraryError(message: e.toString()));
      }
    });
  }
}