part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersListChanged extends OrdersState {
  final List<String> names;

  OrdersListChanged(this.names);
}
