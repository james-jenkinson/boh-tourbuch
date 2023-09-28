import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  List<String> names = [
    "John Marston",
    "Tomislav Piplica",
    "Fredi Bobic",
    "Theo Walcott",
    "Jaromir Jagr",
    "Ludwig Walter",
    "Karl Marx",
    "Tamara Bunke"
  ];

  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) {
      if (event is OrdersListFilterEvent) {
        emit(OrdersListChanged(
            extractAllSorted(query: event.filter, choices: names)
                .map((e) => e.choice)
                .toList()));
      }
    });
  }
}
