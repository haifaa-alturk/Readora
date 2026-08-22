class Endpoints {
  Endpoints._();

  static const String baseUrl = 'http://10.243.228.50:8000/api/';

  static const String user = '/user';

  static const String walletCharge = '/wallet_charge';

  static const String profile = '/profile';

  static const String purchaseHistory = '/purchase-history';

  static String profileById(String id) => '/profile/$id';

  static const String quotes = '/quotes';

  static String quoteById(int id) => '/quotes/$id';

  static const String wins = '/wins';

  static const String totalPoints = '/points/total';

  static const String pointsHistory = '/points/history';

  static const String userBooks = '/library/books';

  static const String interests = '/interests';

  static const String updateInterests = '/profile/interests';

  static const String settings = '/settings';

  static String updateProfile = '/profile';

  static String uploadProfileImage = '/profile/image';

  static String individualChallengeQuestions(int bookId) =>
      '/books/$bookId/challenge-questions';

  static const String individualChallengeSubmit =
      '/challenges/individual/submit';

  // Group Challenges - GitHub version
  static const String groupEventsCurrent = '/challenges/group/current';

  static const String groupEventsEnded = '/challenges/group/ended';

  static const String groupEventsUpcoming = '/challenges/group/upcoming';

  static const String groupEventsMy = '/challenges/group/mine';

  static String registerGroupEvent(int eventId) =>
      '/challenges/group/$eventId/register';

  static String groupEventWinners(int eventId) =>
      '/challenges/group/$eventId/winners';

  static const String recordGroupBookQuizResult =
      '/challenges/group/book-result';

  // Group Challenges - previous/local version
  static const String activeGroupChallenge = '/challenges/group/active';

  static String joinGroupChallenge(int challengeId) =>
      '/challenges/group/$challengeId/join';

  static String groupChallengeWinners(int challengeId) =>
      '/challenges/group/$challengeId/winners';
}
