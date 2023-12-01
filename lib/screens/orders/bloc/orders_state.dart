part of 'orders_bloc.dart';

enum OrdersScreenState { initial, data, navigateToPerson }

@freezed
class OrdersState with _$OrdersState {
  const factory OrdersState({
    @Default(OrdersScreenState.initial) OrdersScreenState status,
    @Default([]) List<ProductTypeWithSelection> productTypes,
    @Default([]) List<OrderTableRow> tableRows,
    @Default(null) int? sortIndex,
    @Default(-1) int sortFieldId,
    @Default(true) bool asc,
    @Default(null) Person? person,
  }) = _OrdersState;
}