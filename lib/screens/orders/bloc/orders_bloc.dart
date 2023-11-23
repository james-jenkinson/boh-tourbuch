import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/order.dart';
import '../../../models/person.dart';
import '../../../repository/order_repository.dart';
import '../../../repository/person_repository.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final PersonRepository _personRepository = PersonRepository();
  final OrderRepository _orderRepository = OrderRepository();

  late Person _selectedPerson;
  late List<Order> _orders;

  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) async {
      if (event is OrdersInitialEvent) {
        _selectedPerson = event.selectedPerson;
        _orders =
            await _orderRepository.getOrdersByPersonId(_selectedPerson.id);
        emit(OrdersLoaded(_selectedPerson, _orders));
      } else if (event is OrdersAddEvent) {
        emit(NavigateToNewOrder(_selectedPerson));
        /*
        await _orderRepository.createOrder(
            Order(personId: _selectedPerson.id, orderDate: DateTime.now()));
        List<Order> orders =
            await _orderRepository.getOrdersByPersonId(_selectedPerson.id);
        emit(OrdersLoaded(_selectedPerson, orders));
         */
      } else if (event is NavigateBackFromNewOrderEvent) {
        final List<Order> orders =
            await _orderRepository.getOrdersByPersonId(_selectedPerson.id);
        emit(OrdersLoaded(_selectedPerson, orders));
      } else if (event is PersonEditedEvent) {
        if (event.personEdited == true) {
          _selectedPerson = (await _personRepository
              .getPersonById(_selectedPerson.id))!; // person must be defined
          emit(OrdersLoaded(_selectedPerson, _orders));
        }
      }
    });
  }
}
