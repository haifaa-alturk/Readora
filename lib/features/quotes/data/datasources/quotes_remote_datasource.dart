import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../../../../core/network_dev3/endpoints.dart';
import '../models/quote_model.dart';

abstract class QuotesRemoteDataSource {
  Future<List<QuoteModel>> getQuotes();
  Future<bool> deleteQuote(int quoteId);
  Future<QuoteModel> addQuote({required int bookId, required String quoteText});
}

class QuotesRemoteDataSourceImpl implements QuotesRemoteDataSource {
  final Dev3ApiClient _apiClient;

  QuotesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<QuoteModel>> getQuotes() async {
    if (useMockData) {
      final data = MockDataProvider.quotesList();
      return data.map((e) => QuoteModel.fromJson(e)).toList();
    }
    final response = await _apiClient.get(Endpoints.quotes);
    final list = response.data as List<dynamic>;
    return list
        .map((e) => QuoteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<bool> deleteQuote(int quoteId) async {
    if (useMockData) {
      return true;
    }
    final response = await _apiClient.delete(Endpoints.quoteById(quoteId));
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<QuoteModel> addQuote(
      {required int bookId, required String quoteText}) async {
    if (useMockData) {
      return QuoteModel(
        id: DateTime.now().millisecondsSinceEpoch,
        bookId: bookId,
        bookTitle: '',
        quoteText: quoteText,
        createdAt: DateTime.now(),
      );
    }
    final response = await _apiClient.post(
      Endpoints.quotes,
      data: {'book_id': bookId, 'quote_text': quoteText},
    );
    return QuoteModel.fromJson(response.data as Map<String, dynamic>);
  }
}