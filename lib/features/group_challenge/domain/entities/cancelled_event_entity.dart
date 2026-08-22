class CancelledEventEntity {
  final int id;
  final String title;
  final DateTime startDate;
  final DateTime cancelledAt;

  const CancelledEventEntity({
    required this.id,
    required this.title,
    required this.startDate,
    required this.cancelledAt,
  });
}
