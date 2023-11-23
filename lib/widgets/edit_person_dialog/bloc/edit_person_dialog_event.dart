part of 'edit_person_dialog_bloc.dart';

@freezed
class EditPersonDialogEvent with _$EditPersonDialogEvent {
const factory EditPersonDialogEvent.setPerson(Person person) = SetPersonEvent;
const factory EditPersonDialogEvent.updateName(String name) = UpdateNameEvent;
const factory EditPersonDialogEvent.updateBlocked(bool blocked) = UpdateBlockedEvent;
const factory EditPersonDialogEvent.updateComment(String comment) = UpdateCommentEvent;
const factory EditPersonDialogEvent.cancel() = CancelEvent;
const factory EditPersonDialogEvent.save() = SaveEvent;
}