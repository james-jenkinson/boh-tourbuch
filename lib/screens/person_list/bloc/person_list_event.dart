part of 'person_list_bloc.dart';

@freezed
class PersonListEvent with _$PersonListEvent {
  const factory PersonListEvent.loadPersons() = _LoadPersonsEvent;
  const factory PersonListEvent.updateFilter(String name) = _updateFilterEvent;
  const factory PersonListEvent.addPerson() = _AddPersonEvent;
  const factory PersonListEvent.navigateToPerson(Person person) = _NavigateToPersonEvent;
  const factory PersonListEvent.togglePerson(Person person) = _TogglePersonEvent;
  const factory PersonListEvent.setPersonSelectedAndOpenEdit(Person person) = _EditSelectedPersonsEvent;
  const factory PersonListEvent.clearSelection() = _ClearSelectionPersonsEvent;
  const factory PersonListEvent.magnifyPerson(Person person) = _MagnifyPersonEvent;
  const factory PersonListEvent.stopMagnifyPerson() = _StopMagnifyPersonEvent;
}