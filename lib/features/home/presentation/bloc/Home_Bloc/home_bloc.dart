import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';
import '../../../domain/repositories/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<FetchHomeData>((event, emit) async {
      emit(HomeLoading());

      final recommendedResult = await repository.getRecommendedBooks();

      final topRatedResult = await repository.getTopRatedBooks();

      final newBooksResult = await repository.getNewBooks();

      String? errorMessage;

      recommendedResult.fold((error) => errorMessage ??= error, (_) {});

      topRatedResult.fold((error) => errorMessage ??= error, (_) {});

      newBooksResult.fold((error) => errorMessage ??= error, (_) {});

      if (errorMessage != null) {
        emit(HomeError(errorMessage!));
        return;
      }

      emit(
        HomeLoaded(
          recommendedBooks: recommendedResult.getOrElse(() => []),
          topRatedBooks: topRatedResult.getOrElse(() => []),
          newBooks: newBooksResult.getOrElse(() => []),
        ),
      );
    });
  }
}
