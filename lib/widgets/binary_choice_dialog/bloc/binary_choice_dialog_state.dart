part of 'binary_choice_dialog_bloc.dart';

enum BinaryChoiceDialogStatus { initial, cancel, save }

@freezed
class BinaryChoiceDialogState with _$BinaryChoiceDialogState {
  const factory BinaryChoiceDialogState({
    @Default(BinaryChoiceDialogStatus.initial) BinaryChoiceDialogStatus status,
  }) = _BinaryChoiceDialogState;
}
