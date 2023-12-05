part of 'edit_person_dialog_bloc.dart';

enum EditPersonDialogStatus { initial, cancel, save, edit }

@freezed
class EditPersonDialogState with _$EditPersonDialogState {
  const factory EditPersonDialogState({
    @Default(EditPersonDialogStatus.initial) EditPersonDialogStatus status,
    @Default(-1) int id,
    @Default('') String name,
    @Default(null) DateTime? blockedSince,
    @Default('') String comment,
    @Default(null) Person? personToMerge,
  }) = _EditPersonDialogState;
}
