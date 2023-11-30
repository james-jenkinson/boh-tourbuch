import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/person.dart';
import '../../../models/product_order.dart';
import '../../../repository/person_repository.dart';
import '../../../repository/product_order_repository.dart';
import '../../../repository/product_type_repository.dart';
import 'model/order_table_row.dart';
import 'model/product_type_with_selection.dart';

part 'orders_bloc.freezed.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final ProductTypeRepository _productTypeRepository;
  final PersonRepository _personRepository;
  final ProductOrderRepository _productOrderRepository;

  OrdersBloc(this._productTypeRepository, this._personRepository,
      this._productOrderRepository)
      : super(const OrdersState()) {
    on<OrdersEvent>((event, emit) async {
      await event.when(
        initial: () async {
          List<ProductTypeWithSelection> productTypes =
              (await _productTypeRepository.getProductTypes())
                  .map((e) => ProductTypeWithSelection(
                      name: e.name, symbol: e.symbol, productTypeId: e.id))
                  .toList();
          final tableRows = await _getRowsForSelection(productTypes);

          productTypes = productTypes
              .map((productType) => productType.copyWith(
                  amount: tableRows
                      .map((row) => row.productIdOrdered.keys
                          .where((key) => key == productType.productTypeId)
                          .length)
                      .reduce((v, e) => v + e)))
              .toList();

          emit(state.copyWith(
              status: OrdersScreenState.data,
              productTypes: productTypes,
              tableRows: tableRows));
        },
        filterChanged: (visible, productTypeId) async {
          final List<ProductTypeWithSelection> productTypes = state.productTypes
              .map((productType) => productType.productTypeId == productTypeId
                  ? productType.copyWith(selected: visible)
                  : productType)
              .toList();

          emit(state.copyWith(
              productTypes: productTypes,
              tableRows: await _getSortedRows(
                  productTypes, state.sortFieldId, state.asc),
              sortIndex: state.sortIndex == null
                  ? null
                  : min(
                      state.sortIndex!,
                      productTypes
                          .where((productType) => productType.selected)
                          .length)));
        },
        sortChanged: (sortIndex, sortFieldId, sortAsc) async => emit(
          state.copyWith(
              sortIndex: sortIndex,
              sortFieldId: sortFieldId,
              asc: sortAsc,
              tableRows: await _getSortedRows(
                  state.productTypes, sortFieldId, sortAsc)),
        ),
        navigate: (person) async => emit(state.copyWith(
            status: OrdersScreenState.navigateToPerson, person: person)),
        returnFromNavigation: () async =>
            emit(state.copyWith(status: OrdersScreenState.data, person: null)),
      );
    });
  }

  Future<List<OrderTableRow>> _getRowsForSelection(
      List<ProductTypeWithSelection> selectedProductTypes) async {
    final List<Person> persons = await _personRepository.getAllPersons();
    final List<ProductOrder> productOrders =
        await _productOrderRepository.getAllByStatusAndIds(
            OrderStatus.ordered,
            selectedProductTypes
                .where((productType) => productType.selected)
                .map((productType) => productType.productTypeId)
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

  Future<List<OrderTableRow>> _getSortedRows(
      List<ProductTypeWithSelection> selectedProductIds,
      int sortFieldId,
      bool asc) async {
    final List<OrderTableRow> personsWithProducts =
        await _getRowsForSelection(selectedProductIds);
    personsWithProducts.sort((a, b) {
      if (sortFieldId == -1) {
        return a.person.name.compareTo(b.person.name) * (asc ? 1 : -1);
      } else {
        return (a.productIdOrdered[sortFieldId] ??
                    (asc ? DateTime(2161) : DateTime(1161)))
                .compareTo(b.productIdOrdered[sortFieldId] ??
                    (asc ? DateTime(2161) : DateTime(1161))) *
            (asc ? 1 : -1);
      }
    });
    return personsWithProducts;
  }
}
