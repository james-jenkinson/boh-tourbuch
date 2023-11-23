part of 'person_list_bloc.dart';

@freezed
class PersonListEvent with _$PersonListEvent {
  const factory PersonListEvent.loadPersons() = _LoadPersonsEvent;
  const factory PersonListEvent.updateFilter(String name) = _updateFilterEvent;
  const factory PersonListEvent.addPerson() = _AddPersonEvent;
  const factory PersonListEvent.selectPerson(Person person) = _SelectPersonEvent;
}