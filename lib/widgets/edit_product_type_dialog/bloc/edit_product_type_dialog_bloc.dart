import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/product_type.dart';
import '../../../repository/product_type_repository.dart';

part 'edit_product_type_dialog_event.dart';

part 'edit_product_type_dialog_state.dart';

class EditProductTypeDialogBloc
    extends Bloc<EditProductTypeDialogEvent, EditProductTypeDialogState> {
  final ProductType? productType;
  final TextEditingController name = TextEditingController();
  final TextEditingController daysBlocked = TextEditingController();
  final TextEditingController symbol = TextEditingController();
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();

  EditProductTypeDialogBloc(this.productType)
      : super(EditProductTypeDialogInitial(productType, productType != null)) {
    name.text = productType?.name ?? '';
    daysBlocked.text = productType?.daysBlocked.toString() ?? '';
    symbol.text = productType?.symbol.toString() ?? '';

    on<EditProductTypeDialogEvent>((event, emit) async {
      if (event is FormChangedEvent) {
        emit(EditProductTypeDialogInitial(
            productType, event.validate != null && event.validate == true));
      } else if (event is CancelClickedEvent) {
        emit(ClosedDialog(false));
      } else if (event is SaveClickedEvent) {
        if (productType == null) {
          await _productTypeRepository.createProductType(ProductType(
              name: name.value.text,
              symbol: symbol.value.text,
              daysBlocked: int.parse(daysBlocked.value.text),
              deletable: true));
        } else {
          await _productTypeRepository.updateProductType(productType!.copyWith(
              name: name.value.text,
              daysBlocked: int.parse(daysBlocked.value.text),
              symbol: symbol.value.text));
        }
        emit(ClosedDialog(true));
      }
    });
  }

  @override
  Future<void> close() async {
    name.dispose();
    daysBlocked.dispose();
    symbol.dispose();
    await super.close();
  }
}
