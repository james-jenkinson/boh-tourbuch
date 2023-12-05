part of 'person_list_bloc.dart';

enum PersonListStatus { initial, data, navigateToSelected, editSelectedPersons }

@freezed
class PersonListState with _$PersonListState {
  const factory PersonListState({
    @Default(PersonListStatus.initial) PersonListStatus status,
    @Default([]) List<Person> persons,
    @Default([]) List<Person> filteredPersons,
    @Default('') String filter,
    @Default([]) List<Person> selectedPersons,
    @Default(null) Person? magnifiedPerson,
  }) = _PersonListState;
}
