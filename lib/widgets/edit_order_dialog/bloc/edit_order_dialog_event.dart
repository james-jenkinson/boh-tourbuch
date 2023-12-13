part of 'edit_order_dialog_bloc.dart';

@freezed
class EditOrderDialogEvent with _$EditOrderDialogEvent {
const factory EditOrderDialogEvent.setOrder(ProductOrder order) = _SetOrderEvent;
const factory EditOrderDialogEvent.updateOrderStatus(OrderStatus? status) = _UpdateOrderStatus;
const factory EditOrderDialogEvent.updateDate(DateTime? date) = _UpdateDateEvent;
const factory EditOrderDialogEvent.cancel() = _CancelEvent;
const factory EditOrderDialogEvent.save() = _SaveEvent;
}