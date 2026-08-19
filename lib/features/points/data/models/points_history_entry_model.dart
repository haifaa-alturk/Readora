import '../../domain/entities/points_history_entry_entity.dart';

class PointsHistoryEntryModel extends PointsHistoryEntryEntity {
  const PointsHistoryEntryModel({
    required super.type,
    required super.title,
    required super.points,
    required super.date,
  });

  factory PointsHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return PointsHistoryEntryModel(
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      points: json['points'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'points': points,
      'date': date,
    };
  }
}