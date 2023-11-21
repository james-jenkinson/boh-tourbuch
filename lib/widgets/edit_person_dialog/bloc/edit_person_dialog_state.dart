part of 'edit_person_dialog_bloc.dart';

@immutable
abstract class EditPersonDialogState {}

class EditPersonDialogInitialState extends EditPersonDialogState {
  final bool formValid;
  final DateTime? blockedSince;

  EditPersonDialogInitialState(this.formValid, this.blockedSince);
}

class CloseDialogState extends EditPersonDialogState {
  final Person? person;

  CloseDialogState(this.person);
}
