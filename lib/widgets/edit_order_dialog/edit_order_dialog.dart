import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product_order.dart';
import '../../repository/product_order_repository.dart';
import 'bloc/edit_order_dialog_bloc.dart';

class EditOrderDialog extends StatefulWidget {
  final ProductOrder order;

  const EditOrderDialog({super.key, required this.order});

  @override
  State<EditOrderDialog> createState() => _EditOrderDialogState();

  static Future<bool?> open(BuildContext context, ProductOrder order) async {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditOrderDialog(order: order));
  }
}

class _EditOrderDialogState extends State<EditOrderDialog> {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
        create: (_) => EditOrderDialogBloc(ProductOrderRepository())
          ..add(EditOrderDialogEvent.setOrder(widget.order)),
        child: BlocBuilder<EditOrderDialogBloc, EditOrderDialogState>(
            builder: (context, state) {
          switch (state.status) {
            case EditOrderDialogStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case EditOrderDialogStatus.editing:
              return buildEdit(context.read<EditOrderDialogBloc>(), state);
          }
        }));
  }

  Widget buildEdit(EditOrderDialogBloc bloc, EditOrderDialogState state) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      title: const Center(child: Text('Bestellung bearbeiten')),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<OrderStatus>(
                title: const Text('Nicht Bestellt'),
                value: OrderStatus.notOrdered,
                groupValue: state.orderStatus,
                onChanged: (status) =>
                    bloc.add(EditOrderDialogEvent.updateOrderStatus(status)),
              ),
              RadioListTile<OrderStatus>(
                title: const Text('Bestellt'),
                value: OrderStatus.ordered,
                groupValue: state.orderStatus,
                onChanged: (status) =>
                    bloc.add(EditOrderDialogEvent.updateOrderStatus(status)),
              ),
              RadioListTile<OrderStatus>(
                title: const Text('Erhalten'),
                value: OrderStatus.received,
                groupValue: state.orderStatus,
                onChanged: (status) =>
                    bloc.add(EditOrderDialogEvent.updateOrderStatus(status)),
              ),
              if (state.orderStatus != OrderStatus.notOrdered)
                CalendarDatePicker(
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2014),
                    lastDate: DateTime.now(),
                    onDateChanged: (date) =>
                        bloc.add(EditOrderDialogEvent.updateDate(date)))
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => bloc.add(const EditOrderDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: () => bloc.add(const EditOrderDialogEvent.save()),
            child: const Text('Speichern'))
      ],
    );
  }
}
