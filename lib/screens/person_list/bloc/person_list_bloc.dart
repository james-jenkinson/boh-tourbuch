import 'package:collection/collection.dart';
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
          const initialFilter = '';
          emit(PersonListState(
              status: PersonListStatus.data,
              persons: persons,
              selectedPersons: [],
              filter: initialFilter,
              filteredPersons: applyFilter(persons, initialFilter)));
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
        navigateToPerson: (person) async => emit(state.copyWith(
            status: PersonListStatus.navigateToSelected,
            selectedPersons: [person])),
        togglePerson: (person) async {
          final isSelected = state.selectedPersons
              .firstWhereOrNull((item) => item.id == person.id);
          if (isSelected == null) {
            emit(state
                .copyWith(selectedPersons: [...state.selectedPersons, person]));
          } else {
            emit(state.copyWith(selectedPersons: [
              ...state.selectedPersons.where((item) => item.id != person.id)
            ]));
          }
        },
        setPersonSelectedAndOpenEdit: (person) async {
          final nextSelectedPersons = null ==
                  state.selectedPersons
                      .firstWhereOrNull((item) => item.id == person.id)
              ? [...state.selectedPersons, person]
              : state.selectedPersons;
          emit(state.copyWith(
              selectedPersons: nextSelectedPersons,
              status: PersonListStatus.editSelectedPersons));
        },
        clearSelection: () async => emit(
            state.copyWith(status: PersonListStatus.data, selectedPersons: [])),
        magnifyPerson: (person) async =>
            emit(state.copyWith(magnifiedPerson: person)),
        stopMagnifyPerson: () async =>
            emit(state.copyWith(magnifiedPerson: null)),
      );
    });
  }

  static List<Person> applyFilter(List<Person> persons, String filter) {
    if (filter.isEmpty) {
      return persons;
    }

    return extractAllSorted(
            query: filter,
            choices: persons,
            cutoff: 35,
            getter: (person) => person.name)
        .map((result) => result.choice)
        .toList();
  }
}
