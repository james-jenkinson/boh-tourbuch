part of 'new_order_bloc.dart';

@immutable
abstract class NewOrderState {}

class NewOrderInitialState extends NewOrderState {}

class NewOrderUpdatedState extends NewOrderState {
  final List<(ProductType, bool)> productTypes;

  NewOrderUpdatedState(this.productTypes);
}

class NewOrderSavedState extends NewOrderState {}
