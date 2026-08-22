import '../../../../core/api/api_client.dart';
import '../models/win_model.dart';

abstract class WinsRemoteDataSource {
  Future<List<WinModel>> getWins();
  Future<List<WinModel>> addWin(WinModel win);
  Future<List<WinModel>> removeWin(int winId);
}

class WinsRemoteDataSourceImpl implements WinsRemoteDataSource {
  WinsRemoteDataSourceImpl(this._realApiClient);

  final ApiClient _realApiClient;

  /// In-memory list seeded from GET my_wins; addWin/removeWin operate on it
  /// so group-challenge instant wins appear immediately without a refetch.
  List<WinModel>? _cachedWins;

  static const _months = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
  };

  /// Parses both ISO-8601 timestamps (joined_at / finished_at) and the
  /// backend's formatted quiz dates ('d M Y', e.g. '21 Aug 2026').
  static DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    final s = raw.toString().trim();
    if (s.isEmpty) return null;
    final iso = DateTime.tryParse(s);
    if (iso != null) return iso;
    final parts = s.split(RegExp(r'\s+'));
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = _months[parts[1]];
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  static int _parsePoints(dynamic raw) =>
      int.tryParse('${raw ?? 0}') ?? 0;

  /// Parses the getMyWinsOverview payload:
  /// { status, total_wins, wins[], events[], quizzes[] }
  /// events[]  -> group-challenge wins (id, event_name, points,
  ///              start_date, end_date, joined_at, finished_at)
  /// quizzes[] -> individual quiz wins (type:'Quiz', title, points:int, date)
  List<WinModel> _parseOverview(dynamic data) {
    final json = Map<String, dynamic>.from(data as Map);
    final wins = <WinModel>[];

    final events = json['events'] as List<dynamic>? ?? const [];
    var syntheticId = 0;
    for (final e in events) {
      final map = Map<String, dynamic>.from(e as Map);
      syntheticId++;
      wins.add(WinModel(
        id: map['id'] as int? ?? -syntheticId,
        title: map['event_name'] as String? ?? '',
        description: '',
        iconName: 'emoji_events',
        type: 'event',
        challengeType: 'group',
        challengeId: map['id'] as int?,
        earnedPoints: _parsePoints(map['points']),
        completedDate: _parseDate(map['finished_at']),
        dateEarned: _parseDate(map['joined_at']),
      ));
    }

    // Quiz rows carry no id — synthesize negative ids so they never collide
    // with real event/book ids.
    final quizzes = json['quizzes'] as List<dynamic>? ?? const [];
    for (final q in quizzes) {
      final map = Map<String, dynamic>.from(q as Map);
      syntheticId++;
      wins.add(WinModel(
        id: -100000 - syntheticId,
        title: map['title'] as String? ?? '',
        description: '',
        iconName: 'emoji_events',
        type: 'quiz',
        challengeType: 'individual',
        earnedPoints: _parsePoints(map['points']),
        completedDate: _parseDate(map['date']),
      ));
    }

    _sortNewestFirst(wins);
    return wins;
  }

  void _sortNewestFirst(List<WinModel> wins) {
    wins.sort((a, b) {
      final aDate = a.completedDate ?? a.dateEarned ?? DateTime(0);
      final bDate = b.completedDate ?? b.dateEarned ?? DateTime(0);
      return bDate.compareTo(aDate);
    });
  }

  @override
  Future<List<WinModel>> getWins() async {
    final response = await _realApiClient.dio.get('my_wins');
    _cachedWins = _parseOverview(response.data);
    return List.from(_cachedWins!);
  }

  @override
  Future<List<WinModel>> addWin(WinModel win) async {
    _cachedWins ??= [];
    _cachedWins!.insert(0, win);
    _sortNewestFirst(_cachedWins!);
    return List.from(_cachedWins!);
  }

  @override
  Future<List<WinModel>> removeWin(int winId) async {
    _cachedWins?.removeWhere((w) => w.id == winId);
    return List.from(_cachedWins ?? const []);
  }
}
