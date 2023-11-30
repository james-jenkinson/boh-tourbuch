part of 'edit_text_dialog_bloc.dart';

enum EditTextDialogStatus { initial, edit, cancel, save }

@freezed
class EditTextDialogState with _$EditTextDialogState {
  const factory EditTextDialogState({
    @Default(EditTextDialogStatus.initial) EditTextDialogStatus status,
    @Default('') String content,
  }) = _EditTextDialogState;
}
