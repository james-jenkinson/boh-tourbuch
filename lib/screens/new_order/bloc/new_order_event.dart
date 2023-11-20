part of 'new_order_bloc.dart';

@immutable
abstract class NewOrderEvent {}

class NewOrderInitialEvent extends NewOrderEvent {
  final Person selectedPerson;

  NewOrderInitialEvent(this.selectedPerson);
}

class NewOrderProductSelectionChangedEvent extends NewOrderEvent {
  // The product type for which the selection status has changed.
  final ProductType productType;

  NewOrderProductSelectionChangedEvent(this.productType);
}

class NewOrderSaveEvent extends NewOrderEvent {}
