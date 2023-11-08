part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {
}

class OrdersListChanged extends OrdersState {
  final List<Person> persons;

  OrdersListChanged(this.persons);
}
