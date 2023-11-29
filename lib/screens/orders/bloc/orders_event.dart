part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class InitialOrdersEvents extends OrdersEvent {

  InitialOrdersEvents();
}
class FilterChangedOrdersEvent extends OrdersEvent {
  final bool visible;
  final int productTypeId;

  FilterChangedOrdersEvent(this.visible, this.productTypeId);
}

class SortChangedOrdersEvent extends OrdersEvent {
  final int sortIndex;
  final int sortFieldId; // productTypeId, name=-1
  final bool sortAsc;

  SortChangedOrdersEvent(this.sortIndex, this.sortFieldId, this.sortAsc);
}

class NavigateToPersonOrdersEvent extends OrdersEvent {
  final Person person;

  NavigateToPersonOrdersEvent(this.person);
}

class ReturnFromPersonOrdersEvent extends OrdersEvent {
  ReturnFromPersonOrdersEvent();
}