import 'package:boh_tourbuch/models/person.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

part 'person_list_event.dart';
part 'person_list_state.dart';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final _personRepository = PersonRepository();

  String _filter = '';

  PersonListBloc() : super(PersonListInitial()) {
    on<PersonListEvent>((event, emit) async {
      if (event is PersonListFilterEvent) {
        _filter = event.filter;
        final persons = await _personRepository.getAllPersons();
        if (_filter.isEmpty) {
          emit(PersonListChanged(persons));
          return;
        }
        final filteredPersons = extractAllSorted(
            query: event.filter,
            choices: persons,
            cutoff: 35,
            getter: (person) => '${person.firstName} ${person.lastName}');
        emit(PersonListChanged(filteredPersons
            .map((extractedResult) => extractedResult.choice)
            .toList()));
      } else if (event is PersonListAddEvent) {
        await _personRepository.createPerson(Person(firstName: _filter, lastName: _filter));
        final persons = await _personRepository.getAllPersons();
        emit(PersonListChanged(persons));
      } else if (event is PersonListNavigateEvent) {
        emit(PersonListNavigateToOrder(event.person));
      }
    });
  }
}
