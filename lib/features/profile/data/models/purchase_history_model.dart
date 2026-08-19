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
    final rawType = (json['type'] as String? ?? '').toLowerCase();

    return PurchaseHistoryModel(
      id: json['id'] as int? ?? 0,
      bookTitle: (json['title'] as String? ?? json['book_title'] as String? ?? ''),
      type: rawType.isEmpty ? 'purchase' : rawType,
      price: _parsePrice(json['price']),
      purchaseDate: (json['date'] as String? ??
          json['purchase_date'] as String? ??
          ''),
    );
  }

  // يقبل القيمة الرقمية مباشرة أو النص المنسّق مثل "Purchase 125000 SYP"
  static double _parsePrice(dynamic raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String) {
      final cleaned = raw.replaceAll(',', '');
      final match = RegExp(r'\d+(\.\d+)?').firstMatch(cleaned);
      if (match != null) {
        return double.tryParse(match.group(0)!) ?? 0.0;
      }
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_title': bookTitle,
      'type': type,
      'price': price,
      'purchase_date': purchaseDate,
    };
  }
}