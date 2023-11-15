part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class LoadOrdersEvent extends SettingsEvent {
  LoadOrdersEvent();
}

class AddProductTypeEvent extends SettingsEvent {
  AddProductTypeEvent();
}

class DeleteProductTypeEvent extends SettingsEvent {
  final int productTypeId;

  DeleteProductTypeEvent(this.productTypeId);
}

class OpenProductTypeDialogEvent extends SettingsEvent {
  final ProductType? productType;

  OpenProductTypeDialogEvent(this.productType);
}

class DialogClosedEvent extends SettingsEvent {
  final bool saveClicked;

  DialogClosedEvent(this.saveClicked);
}

class FormChangedEvent extends SettingsEvent {
  final bool? validate;

  FormChangedEvent(this.validate);
}