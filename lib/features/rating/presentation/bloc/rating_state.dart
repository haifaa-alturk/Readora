abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final int rating;

  RatingSuccess(this.rating);
}

class RatingError extends RatingState {
  final String message;

  RatingError(this.message);
}
