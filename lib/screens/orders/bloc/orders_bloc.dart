import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/person.dart';
import '../../../models/product_order.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/product_order_repository.dart';
import '../../../repository/product_type_repository.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final ProductTypeRepository _productTypeRepository = ProductTypeRepository();
  final PersonRepository _personRepository = PersonRepository();
  final ProductOrderRepository _productOrderRepository =
      ProductOrderRepository();

  late List<ProductTypeWithSelection> _productTypeWithSelections;

  int? _sortIndex;
  bool _asc = true;
  int _sortFieldId = -1;

  OrdersBloc() : super(InitialOrdersState()) {
    on<OrdersEvent>((event, emit) async {
      if (event is InitialOrdersEvents) {
        _productTypeWithSelections =
            (await _productTypeRepository.getProductTypes())
                .map((e) => ProductTypeWithSelection(
                    name: e.name, symbol: e.symbol, productTypeId: e.id))
                .toList();
        final List<OrderTableRow> tableRows =
            await getRowsForSelection(_productTypeWithSelections);

        for (final productType in _productTypeWithSelections) {
          productType.amount = tableRows
              .map((row) => row.productIdOrdered.keys
                  .where((key) => key == productType.productTypeId)
                  .length)
              .reduce((v, e) => v + e);
        }

        emit(LoadedOrdersState(
            sortIndex: _sortIndex,
            asc: _asc,
            productTypes: _productTypeWithSelections,
            tableRows: tableRows));
      } else if (event is FilterChangedOrdersEvent) {
        _productTypeWithSelections
            .firstWhere((productType) =>
                productType.productTypeId == event.productTypeId)
            .selected = event.visible;
        emit(LoadedOrdersState(
            productTypes: _productTypeWithSelections,
            tableRows: await getRowsForSelection(_productTypeWithSelections),
            sortIndex: _sortIndex == null
                ? null
                : min(
                    _sortIndex!,
                    _productTypeWithSelections
                        .where((productType) => productType.selected)
                        .length),
            asc: _asc));
      } else if (event is SortChangedOrdersEvent) {
        _sortIndex = event.sortIndex;
        _asc = event.sortAsc;
        _sortFieldId = event.sortFieldId;

        emit(LoadedOrdersState(
            productTypes: _productTypeWithSelections,
            tableRows: await getSortedRows(_productTypeWithSelections),
            sortIndex: _sortIndex,
            asc: _asc));
      } else if (event is NavigateToPersonOrdersEvent) {
        emit(NavigateToPersonOrdersState(event.person));
      } else if (event is ReturnFromPersonOrdersEvent) {
        emit(LoadedOrdersState(
            productTypes: _productTypeWithSelections,
            tableRows: await getSortedRows(_productTypeWithSelections),
            sortIndex: _sortIndex,
            asc: _asc));
      }
    });
  }

  Future<List<OrderTableRow>> getRowsForSelection(
      List<ProductTypeWithSelection> selectedProductTypes) async {
    final List<Person> persons = await _personRepository.getAllPersons();
    final List<ProductOrder> productOrders =
        await _productOrderRepository.getAllByStatusAndIds(
            OrderStatus.ordered,
            selectedProductTypes
                .where((productType) => productType.selected)
                .map((e) => e.productTypeId)
                .toList());
    final List<OrderTableRow> personsWithProducts = [];

    for (final person in persons) {
      final List<ProductOrder> ordersForPerson = productOrders
          .where((productOrder) => productOrder.personId == person.id)
          .toList();
      if (ordersForPerson.isNotEmpty) {
        personsWithProducts.add(OrderTableRow(
            person: person,
            productIdOrdered: Map.fromIterables(
                ordersForPerson.map((order) => order.productTypeId),
                ordersForPerson.map((order) => order.lastIssueDate))));
      }
    }

    return personsWithProducts;
  }

  Future<List<OrderTableRow>> getSortedRows(
      List<ProductTypeWithSelection> selectedProductIds) async {
    final List<OrderTableRow> personsWithProducts =
        await getRowsForSelection(_productTypeWithSelections);
    personsWithProducts.sort((a, b) {
      if (_sortFieldId == -1) {
        return a.person.name.compareTo(b.person.name) * (_asc ? 1 : -1);
      } else {
        return (a.productIdOrdered[_sortFieldId] ??
                    (_asc ? DateTime(2161) : DateTime(1161)))
                .compareTo(b.productIdOrdered[_sortFieldId] ??
                    (_asc ? DateTime(2161) : DateTime(1161))) *
            (_asc ? 1 : -1);
      }
    });
    return personsWithProducts;
  }
}

class ProductTypeWithSelection {
  bool selected;
  int productTypeId;
  String name;
  String symbol;
  int amount;

  ProductTypeWithSelection(
      {this.selected = true,
      required this.productTypeId,
      required this.name,
      required this.symbol,
      this.amount = 0});
}

class OrderTableRow {
  Person person;
  Map<int, DateTime?> productIdOrdered;

  OrderTableRow({required this.person, required this.productIdOrdered});
}
