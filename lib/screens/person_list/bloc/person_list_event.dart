part of 'person_list_bloc.dart';

@immutable
abstract class PersonListEvent {}

class PersonListFilterEvent extends PersonListEvent {
  final String filter;

  PersonListFilterEvent(this.filter);
}

class PersonListAddEvent extends PersonListEvent {
  PersonListAddEvent();
}
