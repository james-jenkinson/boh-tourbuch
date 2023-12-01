part of 'orders_bloc.dart';

@freezed
class OrdersEvent with _$OrdersEvent {
  const factory OrdersEvent.initial() = _InitialEvent;
  const factory OrdersEvent.filterChanged(bool visible, int productTypeId) = _FilterChangedEvent;
  const factory OrdersEvent.sortChanged(int sortIndex, int sortFieldId, bool sortAsc) = _SortChangedEvent;
  const factory OrdersEvent.navigate(Person person) = _NavigateEvent;
  const factory OrdersEvent.returnFromNavigation() = _ReturnFromNavigationEvent;
}
