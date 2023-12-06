import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/person_repository.dart';
import '../../repository/product_order_repository.dart';
import '../../repository/product_type_repository.dart';
import '../../until/date_time_ext.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/model/order_table_row.dart';
import 'bloc/model/product_type_with_selection.dart';
import 'bloc/orders_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersBloc(
          ProductTypeRepository(), PersonRepository(), ProductOrderRepository())
        ..add(const OrdersEvent.initial()),
      child: Builder(builder: (context) {
        return BlocConsumer<OrdersBloc, OrdersState>(
            bloc: context.read<OrdersBloc>(),
            listener: (context, state) async {
              switch (state.status) {
                case OrdersScreenState.navigateToPerson:
                  await Navigator.pushNamed(context, '/person',
                          arguments: state.person)
                      .then((value) => context
                          .read<OrdersBloc>()
                          .add(const OrdersEvent.returnFromNavigation()));
                default:
              }
            },
            builder: (context, state) {
              final ordersBloc = context.read<OrdersBloc>();
              switch (state.status) {
                case OrdersScreenState.initial:
                case OrdersScreenState.navigateToPerson:
                  return const Center(child: CircularProgressIndicator());
                case OrdersScreenState.data:
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: getFilterChips(state, ordersBloc.add),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child:
                                  getScrollableDataTable(state, ordersBloc.add),
                            ),
                          ),
                        ],
                      ));
              }
            });
      }),
    );
  }

  Wrap getFilterChips(OrdersState state, void Function(OrdersEvent) addEvent) {
    return Wrap(
      spacing: 8,
      children: state.productTypes
          .map((productType) => FilterChip(
                label: Text('${productType.symbol} ${productType.name}'),
                onSelected: (visible) => addEvent(OrdersEvent.filterChanged(
                    visible, productType.productTypeId)),
                selected: productType.selected,
              ))
          .toList(),
    );
  }

  LayoutBuilder getScrollableDataTable(
      OrdersState state, void Function(OrdersEvent) addEvent) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              showCheckboxColumn: false,
              sortColumnIndex: state.sortIndex,
              sortAscending: state.asc,
              columns: [
                DataColumn(
                    label: const Text('Name'),
                    onSort: (index, asc) {
                      addEvent(OrdersEvent.sortChanged(index, -1, asc));
                    }),
                ...getDataColumns(state.productTypes, addEvent)
              ],
              rows: tableRowsToDataRows(
                  state.tableRows, state.productTypes, addEvent),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> tableRowsToDataRows(
      List<OrderTableRow> tableRows,
      List<ProductTypeWithSelection> productTypes,
      void Function(OrdersEvent) addEvent) {
    return tableRows
        .map((row) => DataRow(
              onSelectChanged: (selected) =>
                  addEvent(OrdersEvent.navigate(row.person)),
              cells: [
                DataCell(PersonText(person: row.person)),
                ...productTypes
                    .where((productType) => productType.selected)
                    .map(
                      (productTypes) => DataCell(
                        Text(
                          row.productIdOrdered[productTypes.productTypeId]
                                  ?.toCalendarDate() ??
                              '',
                        ),
                      ),
                    ),
              ],
            ))
        .toList();
  }

  List<DataColumn> getDataColumns(List<ProductTypeWithSelection> productTypes,
      void Function(OrdersEvent) addEvent) {
    return productTypes
        .where((productType) => productType.selected)
        .map((productType) => DataColumn(
            label: Text(
                '${productType.symbol} ${productType.name} (${productType.amount})'),
            onSort: (index, asc) => addEvent(OrdersEvent.sortChanged(
                index, productType.productTypeId, asc))))
        .toList();
  }
}
