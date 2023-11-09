part of 'person_list_bloc.dart';

@immutable
abstract class PersonListState {}

class PersonListInitial extends PersonListState {
}

class PersonListChanged extends PersonListState {
  final List<Person> persons;

  PersonListChanged(this.persons);
}

class PersonListNavigateToOrder extends PersonListState {
  final Person selectedPerson;

  PersonListNavigateToOrder(this.selectedPerson);
}