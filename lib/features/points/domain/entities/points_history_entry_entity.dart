/// Currently valid sources: 'Quiz', 'Reward', and 'Challenge'
/// (Challenge = points earned from winning a Group Challenge).
/// TODO: confirm with backend that these are the only valid source types.
class PointsHistoryEntryEntity {
  final int id;
  final int pointsAmount;
  final String source;
  final DateTime date;

  const PointsHistoryEntryEntity({
    required this.id,
    required this.pointsAmount,
    required this.source,
    required this.date,
  });

  bool get isPositive => pointsAmount >= 0;
}