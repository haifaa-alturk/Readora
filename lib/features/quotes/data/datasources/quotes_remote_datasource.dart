import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quote_model.dart';

abstract class QuotesRemoteDataSource {
  Future<List<QuoteModel>> getQuotes();

  Future<bool> deleteQuote(int quoteId);

  Future<QuoteModel> addQuote({
    required int bookId,
    required String quoteText,
    String bookTitle,
  });
}

class QuotesRemoteDataSourceImpl implements QuotesRemoteDataSource {
  static const String _quotesKey = 'saved_quotes';

  Future<SharedPreferences> _getPrefs() async {
    return SharedPreferences.getInstance();
  }

  // ============================================================
  // GET LOCAL QUOTES
  // ============================================================

  @override
  Future<List<QuoteModel>> getQuotes() async {
    final prefs = await _getPrefs();

    final storedData = prefs.getString(_quotesKey);

    if (storedData == null || storedData.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(storedData);

      if (decoded is! List) {
        return [];
      }

      final List<QuoteModel> quotes = [];

      for (final item in decoded) {
        try {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);

            quotes.add(QuoteModel.fromJson(map));
          }
        } catch (e) {
          // تجاهل الاقتباس التالف فقط
          continue;
        }
      }

      return quotes;
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // ADD LOCAL QUOTE
  // ============================================================

  @override
  Future<QuoteModel> addQuote({
    required int bookId,
    required String quoteText,
    String bookTitle = '',
  }) async {
    final prefs = await _getPrefs();

    final cleanText = quoteText.trim();

    if (cleanText.isEmpty) {
      throw Exception('Quote cannot be empty.');
    }

    final currentQuotes = await getQuotes();

    // ==========================================================
    // PREVENT DUPLICATE
    // ==========================================================

    final existingQuote = currentQuotes.cast<QuoteModel?>().firstWhere(
      (quote) =>
          quote != null &&
          quote.bookId == bookId &&
          quote.quoteText.trim() == cleanText,
      orElse: () => null,
    );

    if (existingQuote != null) {
      return existingQuote;
    }

    // ==========================================================
    // CREATE NEW QUOTE
    // ==========================================================

    final cleanBookTitle = bookTitle.trim();

    final newQuote = QuoteModel(
      id: DateTime.now().millisecondsSinceEpoch,
      bookId: bookId,
      bookTitle: cleanBookTitle.isEmpty ? 'Book #$bookId' : cleanBookTitle,
      quoteText: cleanText,
      createdAt: DateTime.now(),
    );

    final updatedQuotes = <QuoteModel>[newQuote, ...currentQuotes];

    // ==========================================================
    // SAVE
    // ==========================================================

    final encodedData = jsonEncode(
      updatedQuotes.map((quote) => quote.toJson()).toList(),
    );

    final success = await prefs.setString(_quotesKey, encodedData);

    if (!success) {
      throw Exception('Failed to save quote.');
    }

    return newQuote;
  }

  // ============================================================
  // DELETE LOCAL QUOTE
  // ============================================================

  @override
  Future<bool> deleteQuote(int quoteId) async {
    final prefs = await _getPrefs();

    final currentQuotes = await getQuotes();

    final updatedQuotes = currentQuotes
        .where((quote) => quote.id != quoteId)
        .toList();

    final encodedData = jsonEncode(
      updatedQuotes.map((quote) => quote.toJson()).toList(),
    );

    final success = await prefs.setString(_quotesKey, encodedData);

    return success;
  }
}
