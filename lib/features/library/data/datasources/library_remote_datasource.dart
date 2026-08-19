import '../../../../core/api/api_client.dart';
import '../models/library_book_model.dart';

abstract class LibraryRemoteDataSource {
  Future<List<LibraryBookModel>> getUserBooks();
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  LibraryRemoteDataSourceImpl(this._realApiClient);

  final ApiClient _realApiClient;

  @override
  Future<List<LibraryBookModel>> getUserBooks() async {
    final response = await _realApiClient.dio.get('user/my-books');
    final json = Map<String, dynamic>.from(response.data as Map);
    final books = json['books'] as List<dynamic>? ?? const [];
    return books
        .map(
          (e) => LibraryBookModel.fromJson(
            Map<String, dynamic>.from(e as Map),
          ),
        )
        .toList();
  }
}