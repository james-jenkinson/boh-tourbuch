part of 'edit_comment_dialog_bloc.dart';

@freezed
class EditCommentDialogEvent with _$EditCommentDialogEvent {
const factory EditCommentDialogEvent.setComment(String content) = SetCommentEvent;
const factory EditCommentDialogEvent.updateContent(String content) = UpdateContentEvent;
const factory EditCommentDialogEvent.cancel() = CancelEvent;
const factory EditCommentDialogEvent.save() = SaveEvent;
}