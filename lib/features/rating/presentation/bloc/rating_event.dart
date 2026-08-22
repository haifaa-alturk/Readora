abstract class RatingEvent {}

class SubmitRatingEvent extends RatingEvent {
  final int bookId;
  final int rating;

  SubmitRatingEvent({required this.bookId, required this.rating});
}

class UpdateRatingEvent extends RatingEvent {
  final int bookId;
  final int rating;

  UpdateRatingEvent({required this.bookId, required this.rating});
}
