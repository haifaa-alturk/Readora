import 'package:equatable/equatable.dart';

import 'package:library_app1/features/profile/data/models/purchase_history_model.dart';

abstract class PurchaseHistoryState extends Equatable {
  const PurchaseHistoryState();

  @override
  List<Object?> get props => [];
}

class PurchaseHistoryLoading extends PurchaseHistoryState {
  const PurchaseHistoryLoading();
}

class PurchaseHistoryLoaded extends PurchaseHistoryState {
  final List<PurchaseHistoryModel> transactions;

  const PurchaseHistoryLoaded({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class PurchaseHistoryError extends PurchaseHistoryState {
  final String message;

  const PurchaseHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}