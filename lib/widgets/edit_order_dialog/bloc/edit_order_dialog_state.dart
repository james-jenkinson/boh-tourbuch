part of 'edit_order_dialog_bloc.dart';

enum EditOrderDialogStatus { loading, editing }

@freezed
class EditOrderDialogState with _$EditOrderDialogState {
  const factory EditOrderDialogState({
    @Default(EditOrderDialogStatus.loading) EditOrderDialogStatus status,
    ProductOrder? productOrder,
    @Default(OrderStatus.notOrdered) OrderStatus orderStatus,
    DateTime? date
  }) = _EditOrderDialogState;
}
