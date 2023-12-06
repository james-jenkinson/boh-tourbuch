import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_type.freezed.dart';

@freezed
class ProductType with _$ProductType {
  const factory ProductType({
    @Default(-1) int id,
    required String name,
    required String symbol,
    required int daysBlocked,
    required bool deletable,
  }) = _ProductType;
}
