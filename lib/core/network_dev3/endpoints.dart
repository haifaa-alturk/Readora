class Endpoints {
  Endpoints._();

  static const String baseUrl = 'https://api.example.com/v1';

  static const String profile = '/profile';
  static const String purchaseHistory = '/purchase-history';

  static String profileById(String id) => '/profile/$id';

  static const String quotes = '/quotes';
  static String quoteById(int id) => '/quotes/$id';
  static const String wins = '/wins';
  static const String totalPoints = '/points/total';
  static const String pointsHistory = '/points/history';
  static const String userBooks = '/library/books';
  static const String walletBalance = '/wallet/balance';
  static const String walletTransactions = '/wallet/transactions';
  static const String interests = '/interests';
  static const String updateInterests = '/profile/interests';
  static const String settings = '/settings';
  static String updateProfile = '/profile';
  static String uploadProfileImage = '/profile/image';

  static String individualChallengeQuestions(int bookId) => '/books/$bookId/challenge-questions';
  static const String individualChallengeSubmit = '/challenges/individual/submit';

  static const String activeGroupChallenge = '/challenges/group/active';
  static String joinGroupChallenge(int challengeId) => '/challenges/group/$challengeId/join';
  static String groupChallengeWinners(int challengeId) => '/challenges/group/$challengeId/winners';
}