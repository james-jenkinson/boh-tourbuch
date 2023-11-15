part of 'edit_product_type_dialog_bloc.dart';

@immutable
abstract class EditProductTypeDialogState {}

class EditProductTypeDialogInitial extends EditProductTypeDialogState {
  final ProductType? productType;
  final bool validate;

  EditProductTypeDialogInitial(this.productType, this.validate);
}

class ClosedDialog extends EditProductTypeDialogState {
  final bool saveClicked;

  ClosedDialog(this.saveClicked);
}
