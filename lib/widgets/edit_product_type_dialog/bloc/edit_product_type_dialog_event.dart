part of 'edit_product_type_dialog_bloc.dart';

@immutable
abstract class EditProductTypeDialogEvent {}

class FormChangedEvent extends EditProductTypeDialogEvent{
  final bool? validate;
  FormChangedEvent(this.validate);
}

class SaveClickedEvent extends EditProductTypeDialogEvent {
  SaveClickedEvent();
}

class CancelClickedEvent extends EditProductTypeDialogEvent {
  CancelClickedEvent();
}
