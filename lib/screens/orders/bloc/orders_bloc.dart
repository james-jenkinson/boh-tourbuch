import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final _personRepository = PersonRepository();

  String _filter = '';

  OrdersBloc() : super(OrdersInitial()) {
    on<OrdersEvent>((event, emit) async {
      if (event is OrdersListFilterEvent) {
        _filter = event.filter;
        final persons = await _personRepository.getAllPersons();
        if (_filter.isEmpty) {
          emit(OrdersListChanged(persons));
          return;
        }
        final filteredPersons = extractAllSorted(
            query: event.filter,
            choices: persons,
            cutoff: 35,
            getter: (person) => '${person.firstName} ${person.lastName}');
        emit(OrdersListChanged(filteredPersons
            .map((extractedResult) => extractedResult.choice)
            .toList()));
      } else if (event is OrdersAddPersonClickedEvent) {
        await _personRepository.createPerson(Person(firstName: _filter, lastName: _filter));
        final persons = await _personRepository.getAllPersons();
        emit(OrdersListChanged(persons));
      }
    });
  }
}
