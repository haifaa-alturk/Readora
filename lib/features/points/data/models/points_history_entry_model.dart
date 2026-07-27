import '../../domain/entities/points_history_entry_entity.dart';

class PointsHistoryEntryModel extends PointsHistoryEntryEntity {
  const PointsHistoryEntryModel({
    required super.id,
    required super.pointsAmount,
    required super.source,
    required super.date,
  });

  factory PointsHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return PointsHistoryEntryModel(
      id: json['id'] as int? ?? 0,
      pointsAmount: json['points_amount'] as int? ?? 0,
      source: json['source'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points_amount': pointsAmount,
      'source': source,
      'date': date.toIso8601String(),
    };
  }
}