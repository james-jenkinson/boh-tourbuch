import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../until/date_time_ext.dart';
import 'bloc/orders_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    _ordersBloc = OrdersBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _ordersBloc.add(InitialOrdersEvents());
    });
    super.initState();
  }

  @override
  void dispose() {
    _ordersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        listener: (context, state) {
          if (state is NavigateToPersonOrdersState) {
            Navigator.pushNamed(context, '/person', arguments: state.person)
                .then((value) => _ordersBloc.add(ReturnFromPersonOrdersEvent()));
          }
        },
        builder: (context, state) {
          if (state is LoadedOrdersState) {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8,
                        children: state.productTypes
                            .map((productType) => FilterChip(
                                  label: Text(
                                      '${productType.symbol} ${productType.name}'),
                                  onSelected: (visible) => _ordersBloc.add(
                                      FilterChangedOrdersEvent(
                                          visible, productType.productTypeId)),
                                  selected: productType.selected,
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: getScrollableDataTable(state),
                      ),
                    ),
                  ],
                ));
          } else {
            return Container();
          }
        });
  }

  LayoutBuilder getScrollableDataTable(LoadedOrdersState state) {
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
                      _ordersBloc.add(SortChangedOrdersEvent(index, -1, asc));
                    }),
                ...getDataColumns(state.productTypes)
              ],
              rows: tableRowsToDataRows(state.tableRows, state.productTypes),
            ),
          ),
        ),
      ),
    );
  }

  List<DataRow> tableRowsToDataRows(List<OrderTableRow> tableRows,
      List<ProductTypeWithSelection> productTypes) {
    return tableRows
        .map((row) => DataRow(
              onSelectChanged: (selected) =>
                  _ordersBloc.add(NavigateToPersonOrdersEvent(row.person)),
              cells: [
                DataCell(Text(row.person.name)),
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

  List<DataColumn> getDataColumns(List<ProductTypeWithSelection> productTypes) {
    return productTypes
        .where((productType) => productType.selected)
        .map((productType) => DataColumn(
            label: Text(
                '${productType.symbol} ${productType.name} (${productType.amount})'),
            onSort: (index, asc) => _ordersBloc
                .add(SortChangedOrdersEvent(index, productType.productTypeId, asc))))
        .toList();
  }
}
