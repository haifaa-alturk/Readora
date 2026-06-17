import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../domain/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  // قمت بحذف "required HomeRepository homeRepository" الزائدة
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());

      // جلب البيانات من الثلاثة Endpoints
      final recommendedResult = await repository.getRecommendedBooks();
      final topRatedResult = await repository.getTopRatedBooks();
      final newBooksResult = await repository.getNewBooks();
      
      String? errorMessage;
      // نتحقق إذا كان هناك خطأ في أي من الطلبات
      recommendedResult.fold((l) => errorMessage = l, (r) => null);
      topRatedResult.fold((l) => errorMessage = l, (r) => null);
      newBooksResult.fold((l) => errorMessage = l, (r) => null);

      if (errorMessage != null) {
        emit(HomeError(errorMessage!));
      } else {
        emit(HomeLoaded(
          recommendedBooks: recommendedResult.getOrElse(() => []),
          topRatedBooks: topRatedResult.getOrElse(() => []),
          newBooks: newBooksResult.getOrElse(() => []),
        ));
      }
    });
  }
}