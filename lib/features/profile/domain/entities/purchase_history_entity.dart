class PurchaseHistoryEntity {
  final int id;
  final String bookTitle;
  final String type;
  final double price;
  final String purchaseDate;

  const PurchaseHistoryEntity({
    required this.id,
    required this.bookTitle,
    required this.type,
    required this.price,
    required this.purchaseDate,
  });

  bool get isPurchase => type.toLowerCase() == 'purchase';
  bool get isRent => type.toLowerCase() == 'rent';
  String get typeLabel => isPurchase ? 'Purchase' : 'Rent';
}