part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class OrdersListFilterEvent extends OrdersEvent {
  final String filter;

  OrdersListFilterEvent(this.filter);
}

class OrdersAddPersonClickedEvent extends OrdersEvent {
  OrdersAddPersonClickedEvent();
}
