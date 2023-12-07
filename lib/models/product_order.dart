import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_order.freezed.dart';

@freezed
class ProductOrder with _$ProductOrder {
  const factory ProductOrder({
    @Default(-1) int id,
    required int personId,
    DateTime? lastIssueDate,
    required int productTypeId,
    DateTime? lastReceivedDate,
    required OrderStatus status,
  }) = _ProductOrder;

// currently freezed classes can not be directly extended: https://github.com/rrousselGit/freezed/issues/907
  const factory ProductOrder.withSymbol({
    // base values
    required String name,
    required String? symbol,
    required Uint8List? image,
    required int blockedPeriod,

    // extend values
    @Default(-1) int id,
    required int personId,
    DateTime? lastIssueDate,
    required int productTypeId,
    DateTime? lastReceivedDate,
    required OrderStatus status,
  }) = ProductOrderWithSymbol;
}

enum OrderStatus { notOrdered, ordered, received }

bool isNotOrdered(ProductOrder order) => order.status == OrderStatus.notOrdered;

bool isOrdered(ProductOrder order) => order.status == OrderStatus.ordered;

bool isReceived(ProductOrder order) => order.status == OrderStatus.received;
