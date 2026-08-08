import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:library_app1/features/profile/domain/repositories/profile_repository_interface.dart';
import 'purchase_history_event.dart';
import 'purchase_history_state.dart';
import 'package:library_app1/features/profile/data/models/purchase_history_model.dart';

class PurchaseHistoryBloc extends Bloc<PurchaseHistoryEvent, PurchaseHistoryState> {
  final ProfileRepositoryInterface repository;

  PurchaseHistoryBloc({required this.repository}) : super(const PurchaseHistoryLoading()) {
    on<LoadPurchaseHistoryEvent>(_onLoadPurchaseHistory);
  }

  Future<void> _onLoadPurchaseHistory(
    LoadPurchaseHistoryEvent event,
    Emitter<PurchaseHistoryState> emit,
  ) async {
    emit(const PurchaseHistoryLoading());

    final result = await repository.getPurchaseHistory();
    result.fold(
      (error) => emit(PurchaseHistoryError(message: error)),
      (list) {
        // Convert Entity to Model for the state
        final models = list
            .whereType<PurchaseHistoryModel>()
            .toList();
        emit(PurchaseHistoryLoaded(transactions: models));
      },
    );
  }
}