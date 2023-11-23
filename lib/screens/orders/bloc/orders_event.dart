part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class OrdersInitialEvent extends OrdersEvent {
  final Person selectedPerson;

  OrdersInitialEvent(this.selectedPerson);
}

class OrdersAddEvent extends OrdersEvent {

  OrdersAddEvent();
}

class NavigateBackFromNewOrderEvent extends OrdersEvent {
  final Person selectedPerson;

  NavigateBackFromNewOrderEvent(this.selectedPerson);
}

class PersonEditedEvent extends OrdersEvent {
  final bool? personEdited;

  PersonEditedEvent(this.personEdited);
}
