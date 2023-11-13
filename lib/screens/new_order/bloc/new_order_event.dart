part of 'new_order_bloc.dart';

@immutable
abstract class NewOrderEvent {}

class NewOrderInitialEvent extends NewOrderEvent  {
  final Person selectedPerson;

  NewOrderInitialEvent(this.selectedPerson);
}

// Navigation Back
// ...