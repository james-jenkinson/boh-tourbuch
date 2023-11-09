part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final Person selectedPerson;
  final List<Order> orders;

  OrdersLoaded(this.selectedPerson, this.orders);
}
