import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:library_app1/core/api/api_client.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'package:library_app1/features/home/data/models/book_model.dart'; 
 
import 'package:library_app1/features/home/presentation/bloc/Search_Bloc/search_statet.dart';
import 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiClient apiClient = ApiClient();

  SearchBloc() : super(SearchInitial()) {
    on<ExecuteBookSearch>(_onExecuteBookSearch);
  }

  Future<void> _onExecuteBookSearch(
    ExecuteBookSearch event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());

    try {
      final Map<String, dynamic> queryParameters = {};

      // 1. فلترة باسم الكتاب
      if (event.bookName != null && event.bookName!.isNotEmpty) {
        queryParameters['book_name'] = event.bookName;
      }
      // 2. فلترة بالتصنيف (Category)
      if (event.categoryId != null) {
        queryParameters['category_id'] = event.categoryId;
      }
      // 3. فلترة باللغة
      if (event.language != null && event.language!.isNotEmpty) {
        queryParameters['language'] = event.language;
      }
      // 4. فلترة باسم المؤلف (تعديل ليتوافق مع الـ Event الجديد)
      if (event.authorName != null && event.authorName!.isNotEmpty) {
        queryParameters['author_name'] = event.authorName; // ✍️ الباك إند سيستقبل اسم المؤلف كنص للبحث الجزئي
      }
      // 5. فلترة بعدد الصفحات
      if (event.numberOfPagesFrom != null) {
        queryParameters['number_of_pages_from'] = event.numberOfPagesFrom;
      }
      if (event.numberOfPagesTo != null) {
        queryParameters['number_of_pages_to'] = event.numberOfPagesTo;
      }
      // 6. فلترة بأسعار البيع والشراء
      if (event.sellingPriceFrom != null) {
        queryParameters['selling_price_from'] = event.sellingPriceFrom;
      }
      if (event.sellingPriceTo != null) {
        queryParameters['selling_price_to'] = event.sellingPriceTo;
      }

      // إرسال الطلب للسيرفر عبر الراوت المجهز بالباك إند الخاص بكِ
      final response = await apiClient.dio.get(
        '/books/search',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        
        // التحويل باستخدام الـ Model الخاص بكِ لضمان قراءة الخصائص كاملة
        final List<Book> books = data.map((json) => BookModel.fromJson(json)).toList();
        
        emit(SearchSuccess(books: books));
      } else {
        emit(const SearchFailure(errorMessage: 'فشلت عملية جلب البيانات المفلترة'));
      }
    } catch (e) {
      String errorMsg = 'حدث خطأ أثناء الفلترة';
      if (e is DioException) {
        errorMsg = e.response?.data['message'] ?? e.message ?? errorMsg;
      }
      emit(SearchFailure(errorMessage: errorMsg));
    }
  }
}