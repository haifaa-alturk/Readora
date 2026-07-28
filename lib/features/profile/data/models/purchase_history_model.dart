import '../../domain/entities/purchase_history_entity.dart';

class PurchaseHistoryModel extends PurchaseHistoryEntity {
  const PurchaseHistoryModel({
    required super.id,
    required super.bookTitle,
    required super.type,
    required super.price,
    required super.purchaseDate,
  });

  factory PurchaseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryModel(
      id: json['id'] as int? ?? 0,
      bookTitle: json['book_title'] as String? ?? '',
      type: json['type'] as String? ?? 'purchase',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_title': bookTitle,
      'type': type,
      'price': price,
      'purchase_date': purchaseDate.toIso8601String(),
    };
  }
}