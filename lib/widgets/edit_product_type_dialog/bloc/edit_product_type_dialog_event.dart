part of 'edit_product_type_dialog_bloc.dart';


@freezed
class EditProductTypeDialogEvent with _$EditProductTypeDialogEvent {
  const factory EditProductTypeDialogEvent.setProductType(ProductType? productType) = _SetProductTypeEvent;
  const factory EditProductTypeDialogEvent.updateName(String name) = _UpdateNameEvent;
  const factory EditProductTypeDialogEvent.updateDaysBlocked(String daysBlocked) = _UpdateDaysBlockedEvent;
  const factory EditProductTypeDialogEvent.updateSymbol(String symbol) = _UpdateSymbolEvent;
  const factory EditProductTypeDialogEvent.selectImage() = _SelectImageEvent;
  const factory EditProductTypeDialogEvent.clearImage() = _ClearImageEvent;
  const factory EditProductTypeDialogEvent.cancel() = _CancelEvent;
  const factory EditProductTypeDialogEvent.save() = _SaveEvent;
}