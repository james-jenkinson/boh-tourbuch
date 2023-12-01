import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../models/person.dart';

part 'order_table_row.freezed.dart';

@freezed
class OrderTableRow with _$OrderTableRow {
  const factory OrderTableRow(
      {required Person person,
      required Map<int, DateTime?> productIdOrdered}) = _OrderTableRow;
}
