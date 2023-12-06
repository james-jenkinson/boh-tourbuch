import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/product_type.dart';
import '../../../repository/product_type_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) async {
      if (event is LoadOrdersEvent) {
        final List<ProductType> productTypes = await _productTypeRepository.getProductTypes();
        emit(ProductTypesLoaded(productTypes));

      } else if (event is OpenProductTypeDialogEvent) {
        emit(OpenDialog(event.productType));

      } else if (event is DeleteProductTypeEvent) {
        if (event.shouldDelete == true) {
          await _productTypeRepository.deleteProductTypeById(
              event.productTypeId);
          final List<ProductType> productTypes = await _productTypeRepository
              .getProductTypes();
          emit(ProductTypesLoaded(productTypes));
        }

      } else if (event is DialogClosedEvent) {
        final List<ProductType> productTypes = await _productTypeRepository.getProductTypes();
        emit(ProductTypesLoaded(productTypes));
      }
    });
  }

}
