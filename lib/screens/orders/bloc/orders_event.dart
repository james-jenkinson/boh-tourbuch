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