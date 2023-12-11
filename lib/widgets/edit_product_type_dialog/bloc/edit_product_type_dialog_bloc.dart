import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/product_type.dart';
import '../../../repository/product_type_repository.dart';

part 'edit_product_type_dialog_bloc.freezed.dart';

part 'edit_product_type_dialog_event.dart';

part 'edit_product_type_dialog_state.dart';

class EditProductTypeDialogBloc
    extends Bloc<EditProductTypeDialogEvent, EditProductTypeDialogState> {
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();
  final picker = ImagePicker();

  EditProductTypeDialogBloc() : super(const EditProductTypeDialogState()) {
    on<EditProductTypeDialogEvent>((event, emit) async {
      await event.when(
          setProductType: (productType) async {
            if (productType != null) {
              emit(EditProductTypeDialogState(
                  status: EditProductTypeDialogStatus.edit,
                  productType: productType,
                  name: productType.name,
                  daysBlocked: productType.daysBlocked.toString(),
                  symbol: productType.symbol ?? '',
                  imageAsBytes: productType.image));
            } else {
              emit(state.copyWith(status: EditProductTypeDialogStatus.edit));
            }
          },
          updateName: (name) async => emit(state.copyWith(name: name)),
          updateDaysBlocked: (daysBlocked) async =>
              emit(state.copyWith(daysBlocked: daysBlocked)),
          updateSymbol: (symbol) async => emit(state.copyWith(symbol: symbol)),
          cancel: () async =>
              emit(state.copyWith(status: EditProductTypeDialogStatus.cancel)),
          save: () async {
            final productType = state.productType;
            if (productType == null) {
              await _productTypeRepository.createProductType(ProductType(
                name: state.name,
                symbol: state.symbol.isEmpty ? null : state.symbol,
                image: state.imageAsBytes,
                daysBlocked: int.parse(state.daysBlocked),
                deletable: true,
              ));
            } else {
              await _productTypeRepository.updateProductType(
                  productType.copyWith(
                      name: state.name,
                      daysBlocked: int.parse(state.daysBlocked),
                      symbol: state.symbol.isEmpty ? null : state.symbol,
                      image: state.imageAsBytes));
            }

            emit(state.copyWith(status: EditProductTypeDialogStatus.save));
          },
          selectImage: () async {
            final image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              emit(state.copyWith(
                  imageAsBytes: await File(image.path).readAsBytes()));
            }
          },
          clearImage: () async => emit(state.copyWith(imageAsBytes: null)));
    });
  }
}
