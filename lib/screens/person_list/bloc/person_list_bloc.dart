import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import '../../../models/person.dart';
import '../../../repository/person_repository.dart';

part 'person_list_bloc.freezed.dart';

part 'person_list_event.dart';

part 'person_list_state.dart';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final PersonRepository _personRepository;

  PersonListBloc(this._personRepository) : super(const PersonListState()) {
    on<PersonListEvent>((event, emit) async {
      await event.when(
        loadPersons: () async {
          final persons = await _personRepository.getAllPersons();
          emit(
            state.copyWith(
                status: PersonListStatus.data,
                persons: persons,
                filteredPersons: applyFilter(persons, state.filter)),
          );
        },
        updateFilter: (filter) async => emit(state.copyWith(
          filter: filter,
          filteredPersons: applyFilter(state.persons, filter),
        )),
        addPerson: () async {
          final id = await _personRepository.createPerson(Person(
            name: state.filter,
          ));
          final person = await _personRepository.getPersonById(id);
          if (person == null) {
            throw Exception('Person not found');
          }
          emit(state.copyWith(
              status: PersonListStatus.navigateToSelected,
              selectedPersons: [person]));
        },
        selectPerson: (person) async => emit(state.copyWith(
            status: PersonListStatus.navigateToSelected,
            selectedPersons: [person])),
      );
    });
  }

  static List<Person> applyFilter(List<Person> persons, String filter) {
    if (filter.isEmpty) {
      return persons;
    }

    return extractAll(
        query: filter,
        choices: persons,
        cutoff: 35,
        getter: (person) => person.name)
        .map((result) => result.choice)
        .toList();
  }
}
