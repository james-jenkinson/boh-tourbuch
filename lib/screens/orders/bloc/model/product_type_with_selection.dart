import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_type_with_selection.freezed.dart';

@freezed
class ProductTypeWithSelection with _$ProductTypeWithSelection {
  const factory ProductTypeWithSelection({
    required int productTypeId,
    required String name,
    required String? symbol,
    required Uint8List? image,
    @Default(0) int amount,
    @Default(true) bool selected,
  }) = _ProductTypeWithSelection;
}
