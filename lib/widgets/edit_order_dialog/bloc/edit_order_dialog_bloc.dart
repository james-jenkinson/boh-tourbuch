import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/product_order.dart';
import '../../../repository/product_order_repository.dart';
import '../../../until/navigation.dart';

part 'edit_order_dialog_bloc.freezed.dart';

part 'edit_order_dialog_event.dart';

part 'edit_order_dialog_state.dart';

class EditOrderDialogBloc
    extends Bloc<EditOrderDialogEvent, EditOrderDialogState> {
  final ProductOrderRepository _productOrderRepository;

  EditOrderDialogBloc(this._productOrderRepository)
      : super(const EditOrderDialogState()) {
    on<EditOrderDialogEvent>((event, emit) async {
      await event.when(
        setOrder: (order) async {
          emit(state.copyWith(
              status: EditOrderDialogStatus.editing,
              productOrder: order,
              date: _getDate(order),
              orderStatus: order.status));
        },
        updateOrderStatus: (status) async {
          switch (status) {
            case null:
              return;
            case OrderStatus.notOrdered:
              emit(state.copyWith(orderStatus: status, date: null));
            case OrderStatus.ordered:
            case OrderStatus.received:
              emit(state.copyWith(orderStatus: status, date: DateTime.now()));
          }
        },
        updateDate: (date) async => emit(state.copyWith(date: date)),
        cancel: () async => navigator().pop(false),
        save: () async {
          final originalOrder = state.productOrder;
          if (originalOrder == null) {
            return navigator().pop(false);
          }

          final updatedOrder = originalOrder.copyWith(
            status: state.orderStatus,
            lastIssueDate:
                state.orderStatus == OrderStatus.notOrdered ? null : state.date,
            lastReceivedDate:
                state.orderStatus == OrderStatus.received ? state.date : null,
          );
          if (originalOrder.id == -1) {
            await _productOrderRepository.createProductOrder(updatedOrder);
          } else {
            await _productOrderRepository.updateProductOrder(updatedOrder);
          }

          navigator().pop(true);
        },
      );
    });
  }

  DateTime? _getDate(ProductOrder order) {
    switch (order.status) {
      case OrderStatus.notOrdered:
        return null;
      case OrderStatus.ordered:
        return order.lastIssueDate;
      case OrderStatus.received:
        return order.lastReceivedDate;
    }
  }
}
