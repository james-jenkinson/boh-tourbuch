part of 'edit_person_dialog_bloc.dart';

@immutable
abstract class EditPersonDialogEvent {}

class FormChangedEvent extends EditPersonDialogEvent {
  final bool? formValid;

  FormChangedEvent(this.formValid);
}

class BlockedStatusChangedEvent extends EditPersonDialogEvent {
  final bool? formValid;
  BlockedStatusChangedEvent(this.formValid);
}

class CancelClickedEvent extends EditPersonDialogEvent {}
class SaveClickedEvent extends EditPersonDialogEvent {}