import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/features/home/data/datasources/favorite_remote_data_source.dart';
import 'package:library_app1/features/home/domain/entities/book.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRemoteDataSource dataSource;
  List<Book> _currentFavorites = [];

  FavoriteBloc(this.dataSource) : super(FavoriteInitial()) {
    // جلب قائمة المفضلة
    on<FetchFavoritesEvent>((event, emit) async {
      emit(FavoriteLoading());
      try {
        // الـ Data Source أصلح يقرأ التوكين تلقائياً من SharedPreferences
        _currentFavorites = await dataSource.getFavorites();
        emit(FavoriteLoaded(List.from(_currentFavorites)));
      } catch (e) {
        emit(FavoriteError(e.toString()));
      }
    });

    //  إضافة أو حذف كتاب (Toggle)
    on<ToggleFavoriteEvent>((event, emit) async {
      try {
        if (event.isCurrentlyFavorite) {
          // حذف محلي فوري لتحديث الواجهة بسرعة (Optimistic UI)
          _currentFavorites.removeWhere((book) => book.id == event.bookId);
          emit(FavoriteLoaded(List.from(_currentFavorites)));

          // استدعاء الحذف بالتمرير الجديد للـ bookId فقط
          await dataSource.removeFromFavorite(event.bookId);
        } else {
          // استدعاء الإضافة بالتمرير الجديد للـ bookId فقط
          await dataSource.addToFavorite(event.bookId);

          // إعادة جلب المفضلة لتحديث القائمة بالكامل
          add(FetchFavoritesEvent(""));
        }
      } catch (e) {
        // إعادة الجلب لإلغاء التغيير المحلي في حال حدوث أي خطأ في السيرفر
        add(FetchFavoritesEvent(""));
      }
    });
  }
}
