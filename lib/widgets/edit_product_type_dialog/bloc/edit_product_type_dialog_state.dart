part of 'edit_product_type_dialog_bloc.dart';

enum EditProductTypeDialogStatus { initial, cancel, save, edit }

@freezed
class EditProductTypeDialogState with _$EditProductTypeDialogState {
  const factory EditProductTypeDialogState({
    @Default(EditProductTypeDialogStatus.initial)
    EditProductTypeDialogStatus status,
    @Default(null) ProductType? productType,
    @Default('') String name,
    @Default('') String daysBlocked,
    @Default('') String symbol,
    @Default(null) Uint8List? imageAsBytes,
  }) = _EditProductTypeDialogState;
}
