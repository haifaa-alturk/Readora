abstract class BookDetailsEvent {}

class LoadBookDetailsEvent extends BookDetailsEvent {
  final int bookId;

  LoadBookDetailsEvent(this.bookId);
}

class PurchaseBookEvent extends BookDetailsEvent {
  final int bookId;
  final String discountPackage;

  PurchaseBookEvent(this.bookId, [this.discountPackage = 'none']);
}

class BorrowBookEvent extends BookDetailsEvent {
  final int bookId;
  final String discountPackage;

  BorrowBookEvent(this.bookId, [this.discountPackage = 'none']);
}
