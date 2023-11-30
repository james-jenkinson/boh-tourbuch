part of 'edit_text_dialog_bloc.dart';

@freezed
class EditTextDialogEvent with _$EditTextDialogEvent {
  const factory EditTextDialogEvent.setText(String content) = SetTextEvent;

  const factory EditTextDialogEvent.updateContent(String content) =
      UpdateContentEvent;

  const factory EditTextDialogEvent.cancel() = CancelEvent;

  const factory EditTextDialogEvent.save() = SaveEvent;
}
