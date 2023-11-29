part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class LoadedOrdersState extends OrdersState {
  final List<ProductTypeWithSelection> productTypes;
  final List<OrderTableRow> tableRows;
  final int? sortIndex;
  final bool asc;

  LoadedOrdersState({required this.productTypes, required this.tableRows, this.sortIndex, required this.asc});
}

class NavigateToPersonOrdersState extends OrdersState {
  final Person person;

  NavigateToPersonOrdersState(this.person);
}
