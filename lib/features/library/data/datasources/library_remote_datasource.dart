import '../../../../core/mock_dev3/mock_config.dart';
import '../../../../core/mock_dev3/mock_data_provider.dart';
import '../../../../core/network_dev3/api_client.dart';
import '../models/library_book_model.dart';

abstract class LibraryRemoteDataSource {
  Future<List<LibraryBookModel>> getUserBooks();
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  LibraryRemoteDataSourceImpl(this._apiClient);

  // ignore: unused_field — kept for when real API call is uncommented below
  final Dev3ApiClient _apiClient;

  @override
  Future<List<LibraryBookModel>> getUserBooks() async {
    if (useMockData) {
      final data = MockDataProvider.libraryBooks();
      return data.map((e) => LibraryBookModel.fromJson(e)).toList();
    }
    // TODO: confirm real library endpoint with backend team
    // final response = await _apiClient.get('/library/books');
    // final list = response.data as List<dynamic>;
    // return list
    //     .map((e) => LibraryBookModel.fromJson(e as Map<String, dynamic>))
    //     .toList();
    final data = MockDataProvider.libraryBooks();
    return data.map((e) => LibraryBookModel.fromJson(e)).toList();
  }
}