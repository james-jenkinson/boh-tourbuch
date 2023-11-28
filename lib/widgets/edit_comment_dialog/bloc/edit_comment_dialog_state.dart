part of 'edit_comment_dialog_bloc.dart';

enum EditCommentDialogStatus { initial, edit, cancel, save }

@freezed
class EditCommentDialogState with _$EditCommentDialogState {
  const factory EditCommentDialogState({
    @Default(EditCommentDialogStatus.initial) EditCommentDialogStatus status,
    @Default('') String content,
  }) = _EditCommentDialogState;
}
