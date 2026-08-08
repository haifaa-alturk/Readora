class MockDataProvider {
  MockDataProvider._();

  static Map<String, dynamic> profileData() {
    return {
      'name': 'lara',
      'email': 'lara@test.com',
      'points': 100,
      'books_count': 5,
      'wallet_balance': 250.0,
      'image_path': null,
    };
  }

  static List<Map<String, dynamic>> purchaseHistoryList() {
    return [
      {
        'id': 1,
        'book_title': 'Clean Architecture',
        'type': 'purchase',
        'price': 45000,
        'purchase_date': '2026-05-15T10:30:00.000',
      },
      {
        'id': 2,
        'book_title': 'Domain-Driven Design',
        'type': 'purchase',
        'price': 52000,
        'purchase_date': '2026-04-20T14:00:00.000',
      },
      {
        'id': 3,
        'book_title': 'Refactoring',
        'type': 'rent',
        'price': 12000,
        'purchase_date': '2026-06-01T09:15:00.000',
      },
      {
        'id': 4,
        'book_title': 'The Pragmatic Programmer',
        'type': 'purchase',
        'price': 48000,
        'purchase_date': '2026-03-10T11:00:00.000',
      },
      {
        'id': 5,
        'book_title': 'Design Patterns',
        'type': 'purchase',
        'price': 55000,
        'purchase_date': '2026-02-05T16:30:00.000',
      },
      {
        'id': 6,
        'book_title': 'Introduction to Algorithms',
        'type': 'rent',
        'price': 15000,
        'purchase_date': '2026-06-20T08:45:00.000',
      },
      {
        'id': 7,
        'book_title': 'Code Complete',
        'type': 'purchase',
        'price': 42000,
        'purchase_date': '2026-01-18T14:15:00.000',
      },
      {
        'id': 8,
        'book_title': 'Working Effectively with Legacy Code',
        'type': 'rent',
        'price': 9000,
        'purchase_date': '2026-07-02T10:00:00.000',
      },
      {
        'id': 9,
        'book_title': 'The Clean Coder',
        'type': 'purchase',
        'price': 38000,
        'purchase_date': '2026-06-28T13:20:00.000',
      },
      {
        'id': 10,
        'book_title': 'Structure and Interpretation of Computer Programs',
        'type': 'rent',
        'price': 13500,
        'purchase_date': '2026-05-30T09:30:00.000',
      },
    ];
  }

  static List<Map<String, dynamic>> quotesList() {
    return [
      {
        'id': 1,
        'book_id': 101,
        'book_title': 'مقدمة في البرمجة',
        'quote_text': 'جودة البرمجيات ليست مصادفة، بل هي دائماً نتيجة جهد ذكي وبناء متقن.',
        'created_at': '2026-06-17T10:00:00.000',
      },
      {
        'id': 2,
        'book_id': 102,
        'book_title': 'قواعد البيانات',
        'quote_text': 'البيانات المنظمة بشكل جيد هي الأساس الذي تبنى عليه القرارات الذكية والأنظمة الناجحة.',
        'created_at': '2026-06-13T10:00:00.000',
      },
    ];
  }

  static Map<String, dynamic> walletBalance() {
    return {
      'balance': 250000.0,
      'currency': 'SYP',
    };
  }

  static List<Map<String, dynamic>> walletTransactions() {
    return [
      {
        'id': 1,
        'amount': 200000.0,
        'source': 'Recharge',
        'date': '2026-06-15T10:00:00.000',
        'type': 'credit',
      },
      {
        'id': 2,
        'amount': 45000.0,
        'source': 'Purchase',
        'date': '2026-06-10T14:30:00.000',
        'type': 'debit',
      },
      {
        'id': 3,
        'amount': 50000.0,
        'source': 'Recharge',
        'date': '2026-06-01T09:00:00.000',
        'type': 'credit',
      },
      {
        'id': 4,
        'amount': 52000.0,
        'source': 'Purchase',
        'date': '2026-05-20T16:00:00.000',
        'type': 'debit',
      },
      {
        'id': 5,
        'amount': 25000.0,
        'source': 'Refund',
        'date': '2026-05-15T11:00:00.000',
        'type': 'credit',
      },
      {
        'id': 6,
        'amount': 12000.0,
        'source': 'Rent',
        'date': '2026-05-10T08:00:00.000',
        'type': 'debit',
      },
      {
        'id': 7,
        'amount': 30000.0,
        'source': 'Recharge',
        'date': '2026-04-25T15:00:00.000',
        'type': 'credit',
      },
    ];
  }

  static Map<String, dynamic> totalPoints() {
    return {'total_points': 100};
  }

  static List<Map<String, dynamic>> pointsHistory() {
    return [
      {
        'id': 1,
        'points_amount': 50,
        'source': 'Quiz',
        'date': '2026-06-15T10:00:00.000',
      },
      {
        'id': 2,
        'points_amount': 30,
        'source': 'Reward',
        'date': '2026-06-10T14:30:00.000',
      },
      {
        'id': 3,
        'points_amount': 20,
        'source': 'Quiz',
        'date': '2026-06-09T08:00:00.000',
      },
      {
        'id': 4,
        'points_amount': 15,
        'source': 'Reward',
        'date': '2026-06-07T16:00:00.000',
      },
      {
        'id': 5,
        'points_amount': 40,
        'source': 'Quiz',
        'date': '2026-06-05T12:00:00.000',
      },
      {
        'id': 6,
        'points_amount': 25,
        'source': 'Reward',
        'date': '2026-06-01T09:00:00.000',
      },
      {
        'id': 7,
        'points_amount': 10,
        'source': 'Quiz',
        'date': '2026-05-28T11:00:00.000',
      },
      {
        'id': 8,
        'points_amount': 35,
        'source': 'Reward',
        'date': '2026-05-25T15:00:00.000',
      },
      {
        'id': 9,
        'points_amount': -10,
        'source': 'Quiz',
        'date': '2026-05-22T08:00:00.000',
      },
    ];
  }

  static List<Map<String, dynamic>> books() {
    return [
      {
        'id': 101,
        'title': 'Clean Architecture',
        'author': 'Robert C. Martin',
        'cover_url': null,
        'category': 'Software Engineering',
        'price': 45000.0,
        'rating': 4.5,
      },
      {
        'id': 102,
        'title': 'Domain-Driven Design',
        'author': 'Eric Evans',
        'cover_url': null,
        'category': 'Software Engineering',
        'price': 52000.0,
        'rating': 4.3,
      },
      {
        'id': 103,
        'title': 'Refactoring',
        'author': 'Martin Fowler',
        'cover_url': null,
        'category': 'Software Engineering',
        'price': 38000.0,
        'rating': 4.4,
      },
    ];
  }

  static List<Map<String, dynamic>> interests() {
    return [
      {'id': 1, 'name': 'Poetry', 'is_selected': true},
      {'id': 2, 'name': 'Fiction', 'is_selected': true},
      {'id': 3, 'name': 'Science', 'is_selected': false},
      {'id': 4, 'name': 'History', 'is_selected': true},
      {'id': 5, 'name': 'Romance', 'is_selected': false},
      {'id': 6, 'name': 'Mystery', 'is_selected': false},
      {'id': 7, 'name': 'Self-Help', 'is_selected': false},
      {'id': 8, 'name': 'Biography', 'is_selected': false},
    ];
  }

  static List<Map<String, dynamic>> libraryBooks() {
    return [
      {
        'id': 1,
        'title': 'Clean Architecture',
        'author': 'Robert C. Martin',
        'status': 'completed',
        'start_date': '2026-01-15T00:00:00.000',
        'completion_date': '2026-03-20T00:00:00.000',
      },
      {
        'id': 2,
        'title': 'Domain-Driven Design',
        'author': 'Eric Evans',
        'status': 'completed',
        'start_date': '2026-02-01T00:00:00.000',
        'completion_date': '2026-04-10T00:00:00.000',
      },
      {
        'id': 3,
        'title': 'Refactoring',
        'author': 'Martin Fowler',
        'status': 'completed',
        'start_date': '2026-03-05T00:00:00.000',
        'completion_date': '2026-05-15T00:00:00.000',
      },
      {
        'id': 4,
        'title': 'Design Patterns',
        'author': 'GoF',
        'status': 'completed',
        'start_date': '2025-11-01T00:00:00.000',
        'completion_date': '2026-01-20T00:00:00.000',
      },
      {
        'id': 5,
        'title': 'The Pragmatic Programmer',
        'author': 'Andrew Hunt',
        'status': 'in_progress',
        'start_date': '2026-05-01T00:00:00.000',
        'completion_date': null,
      },
      {
        'id': 6,
        'title': 'Introduction to Algorithms',
        'author': 'Thomas H. Cormen',
        'status': 'in_progress',
        'start_date': '2026-04-10T00:00:00.000',
        'completion_date': null,
      },
      {
        'id': 7,
        'title': 'Code Complete',
        'author': 'Steve McConnell',
        'status': 'borrowed',
        'start_date': '2026-06-01T00:00:00.000',
        'completion_date': null,
      },
      {
        'id': 8,
        'title': 'Working Effectively with Legacy Code',
        'author': 'Michael Feathers',
        'status': 'purchased',
        'start_date': null,
        'completion_date': null,
      },
    ];
  }

  static List<Map<String, dynamic>> winsList() {
    return [
      {
        'id': 9001,
        'title': 'Read 3 Books in 5 Days',
        'description': 'Completed',
        'icon_name': 'emoji_events',
        'date_earned': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'type': 'individual_challenge',
        'challenge_id': 501,
        'challenge_type': 'individual',
        'reward': '3 bonus points',
        'earned_points': 3,
        'completed_date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'status': 'completed',
      },
      {
        'id': 9002,
        'title': 'Group Reading Sprint Winner',
        'description': 'Completed',
        'icon_name': 'emoji_events',
        'date_earned': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'type': 'group_challenge',
        'challenge_id': 601,
        'challenge_type': 'group',
        'reward': '5 bonus points',
        'earned_points': 5,
        'completed_date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'status': 'completed',
      },
      {
        'id': 1,
        'title': 'First Purchase',
        'description': 'Completed your first book purchase',
        'icon_name': 'shopping_cart',
        'date_earned': '2026-04-01T10:00:00.000',
        'type': 'achievement',
      },
      {
        'id': 2,
        'title': 'Bookworm',
        'description': 'Read 5 books',
        'icon_name': 'menu_book',
        'date_earned': '2026-05-15T10:00:00.000',
        'type': 'achievement',
      },
      {
        'id': 3,
        'title': 'Quote Master',
        'description': 'Saved 10 quotes',
        'icon_name': 'format_quote',
        'date_earned': null,
        'type': 'achievement',
      },
      {
        'id': 4,
        'title': '10K Points Club',
        'description': 'Earned 10,000 loyalty points',
        'icon_name': 'stars',
        'date_earned': '2026-06-10T10:00:00.000',
        'type': 'reward',
      },
      {
        'id': 5,
        'title': 'Reading Challenge — March',
        'description': 'Spring Reading Marathon',
        'icon_name': 'emoji_events',
        'date_earned': '2026-03-20T14:00:00.000',
        'type': 'ranked',
        'rank': 1,
        'event_name': 'Spring Reading Marathon',
      },
      {
        'id': 6,
        'title': 'Book Club Trivia Night',
        'description': 'Book Club Trivia Night',
        'icon_name': 'emoji_events',
        'date_earned': '2026-04-15T19:30:00.000',
        'type': 'ranked',
        'rank': 2,
        'event_name': 'Book Club Trivia Night',
      },
      {
        'id': 7,
        'title': 'Poetry Slam — April',
        'description': 'Annual Poetry Slam',
        'icon_name': 'emoji_events',
        'date_earned': '2026-04-28T16:00:00.000',
        'type': 'ranked',
        'rank': 3,
        'event_name': 'Annual Poetry Slam',
      },
      {
        'id': 8,
        'title': 'Summer Reading Kickoff',
        'description': 'Summer Reading Kickoff',
        'icon_name': 'emoji_events',
        'date_earned': '2026-06-01T10:00:00.000',
        'type': 'ranked',
        'rank': 2,
        'event_name': 'Summer Reading Kickoff',
      },
    ];
  }

  static List<Map<String, dynamic>> achievements() {
    return [
      {
        'id': 1,
        'title': 'First Purchase',
        'description': '完成了你的第一次购买',
        'icon': 'shopping_cart',
        'unlocked_at': '2026-04-01T10:00:00.000',
      },
      {
        'id': 2,
        'title': 'Bookworm',
        'description': '阅读了 5 本书',
        'icon': 'menu_book',
        'unlocked_at': '2026-05-15T10:00:00.000',
      },
      {
        'id': 3,
        'title': 'Quote Master',
        'description': '收藏了 10 条名言',
        'icon': 'format_quote',
        'unlocked_at': null,
      },
    ];
  }

  static List<Map<String, dynamic>> individualChallengeQuestions(int bookId) {
    return [
      {
        'id': 1,
        'question_text': 'What was the main theme of the book you just finished?',
        'options': ['Personal growth', 'Cooking recipes', 'Car mechanics'],
        'correct_option_index': 0,
      },
      {
        'id': 2,
        'question_text': 'Which skill does reading regularly improve the most?',
        'options': ['Concentration', 'Juggling', 'Swimming'],
        'correct_option_index': 0,
      },
      {
        'id': 3,
        'question_text': 'What should you do right after finishing a great book?',
        'options': ['Forget about it immediately', 'Reflect and pick your next one', 'Never read again'],
        'correct_option_index': 1,
      },
    ];
  }

  static Map<String, dynamic> activeGroupChallenge() {
    return {
      'id': 1,
      'title': 'The Challenge Has Started!',
      'description': 'Read 3 books and successfully pass all quizzes within 5 days.',
      'bonus_points': 5,
      'required_books': 3,
      'required_quizzes': 3,
      'deadline': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'is_joined': false,
      'user_books_completed': 0,
      'user_quizzes_passed': 0,
      'status': 'active',
    };
  }

  static List<Map<String, dynamic>> groupChallengeWinners() {
    return [
      {'user_id': 101, 'username': 'Lara', 'avatar_url': null},
      {'user_id': 102, 'username': 'Omar', 'avatar_url': null},
      {'user_id': 103, 'username': 'Sara', 'avatar_url': null},
    ];
  }
}