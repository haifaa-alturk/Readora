import '../../domain/entities/cancelled_event_entity.dart';

class CancelledEventModel extends CancelledEventEntity {
  const CancelledEventModel({
    required super.id,
    required super.title,
    required super.startDate,
    required super.cancelledAt,
  });

  /// Parses a cancelled Laravel Event resource. The backend has no
  /// `cancelled_at` column, so the event's `updated_at` timestamp is used
  /// as the cancellation date.
  factory CancelledEventModel.fromJson(Map<String, dynamic> json) {
    return CancelledEventModel(
      id: json['id'] as int? ?? 0,
      title: json['event_name'] as String? ?? '',
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : DateTime.now(),
      cancelledAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_name': title,
      'start_date': startDate.toIso8601String(),
      'cancelled_at': cancelledAt.toIso8601String(),
    };
  }
}
