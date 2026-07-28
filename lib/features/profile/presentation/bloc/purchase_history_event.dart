import 'package:equatable/equatable.dart';

abstract class PurchaseHistoryEvent extends Equatable {
  const PurchaseHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadPurchaseHistoryEvent extends PurchaseHistoryEvent {
  const LoadPurchaseHistoryEvent();
}