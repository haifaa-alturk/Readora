import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_book_details.dart';
import 'book_details_event.dart';
import 'book_details_state.dart';

class BookDetailsBloc extends Bloc<BookDetailsEvent, BookDetailsState> {
  final GetBookDetails getBookDetails;

  BookDetailsBloc(this.getBookDetails) : super(BookDetailsInitial()) {
    on<LoadBookDetailsEvent>((event, emit) async {
      print("📚 Loading Book ID: ${event.bookId}");

      emit(BookDetailsLoading());

      final result = await getBookDetails(event.bookId);

      result.fold(
        (failure) {
          emit(BookDetailsError(failure));
        },

        (book) {
          emit(BookDetailsLoaded(book));
        },
      );
    });
  }
}