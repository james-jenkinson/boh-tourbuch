part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class ProductTypesLoaded extends SettingsState {
  final List<ProductType> productTypes;

  ProductTypesLoaded(this.productTypes);
}

class OpenDialog extends SettingsState {
  final ProductType? productType;

  OpenDialog(this.productType);
}