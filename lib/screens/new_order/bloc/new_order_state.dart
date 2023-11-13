part of 'new_order_bloc.dart';

@immutable
abstract class NewOrderState {}

class NewOrderInitialState extends NewOrderState {}

class NewOrderPersonLoaded extends NewOrderState {
  final Person selectedPerson;

  NewOrderPersonLoaded(this.selectedPerson);
}
