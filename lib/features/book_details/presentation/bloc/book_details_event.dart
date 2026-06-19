abstract class BookDetailsEvent {}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final int bookId;

  LoadBookDetailsEvent(this.bookId);

}
