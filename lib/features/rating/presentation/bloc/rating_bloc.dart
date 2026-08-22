import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/rate_book.dart';
import '../../domain/usecases/update_rating.dart';

import 'rating_event.dart';
import 'rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  final RateBook rateBook;
  final UpdateRating updateRating;

  RatingBloc({required this.rateBook, required this.updateRating})
    : super(RatingInitial()) {
    on<SubmitRatingEvent>(_submitRating);
    on<UpdateRatingEvent>(_updateRating);
  }

  Future<void> _submitRating(
    SubmitRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    if (event.rating < 1 || event.rating > 5) {
      emit(RatingError('Rating must be between 1 and 5'));
      return;
    }

    emit(RatingLoading());

    final result = await rateBook(bookId: event.bookId, rating: event.rating);

    result.fold(
      (failure) {
        print('❌ Rating Failed: $failure');

        emit(RatingError(failure));
      },
      (_) {
        print('⭐ Rating Submitted: ${event.rating}');

        emit(RatingSuccess(event.rating));
      },
    );
  }

  Future<void> _updateRating(
    UpdateRatingEvent event,
    Emitter<RatingState> emit,
  ) async {
    if (event.rating < 1 || event.rating > 5) {
      emit(RatingError('Rating must be between 1 and 5'));
      return;
    }

    emit(RatingLoading());

    final result = await updateRating(
      bookId: event.bookId,
      rating: event.rating,
    );

    result.fold(
      (failure) {
        print('❌ Update Rating Failed: $failure');

        emit(RatingError(failure));
      },
      (_) {
        print('✏️ Rating Updated: ${event.rating}');

        emit(RatingSuccess(event.rating));
      },
    );
  }
}
