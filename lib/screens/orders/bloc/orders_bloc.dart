import 'package:boh_tourbuch/repository/order_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/order.dart';
import '../../../models/person.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository _orderRepository = OrderRepository();

  late final Person _selectedPerson;

  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) async {
      if (event is OrdersInitialEvent) {
        _selectedPerson = event.selectedPerson;
        List<Order> orders =
            await _orderRepository.getOrdersByPersonId(_selectedPerson.id);
        emit(OrdersLoaded(_selectedPerson, orders));
      } else if (event is OrdersAddEvent) {
        emit(NavigateToNewOrder(_selectedPerson));
        /*
        await _orderRepository.createOrder(
            Order(personId: _selectedPerson.id, orderDate: DateTime.now()));
        List<Order> orders =
            await _orderRepository.getOrdersByPersonId(_selectedPerson.id);
        emit(OrdersLoaded(_selectedPerson, orders));
         */
      }
    });
  }
}
