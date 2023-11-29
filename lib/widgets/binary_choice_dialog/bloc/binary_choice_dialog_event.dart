part of 'binary_choice_dialog_bloc.dart';

@freezed
class BinaryChoiceDialogEvent with _$BinaryChoiceDialogEvent {
  const factory BinaryChoiceDialogEvent.cancel() = CancelEvent;

  const factory BinaryChoiceDialogEvent.save() = SaveEvent;
}
