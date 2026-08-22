/// Currently valid types: 'Quiz', 'Reward', and 'Challenge'
/// (Challenge = points earned from winning a Group Challenge).
/// TODO: confirm with backend that these are the only valid type values.
class PointsHistoryEntryEntity {
  final String type;
  final String title;
  final String points;
  final String date;

  const PointsHistoryEntryEntity({
    required this.type,
    required this.title,
    required this.points,
    required this.date,
  });

  bool get isPositive => !points.trimLeft().startsWith('-');
}
