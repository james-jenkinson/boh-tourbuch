part of 'person_bloc.dart';

@freezed
class PersonEvent with _$PersonEvent {
  const factory PersonEvent.initial() = _InitialEvent;
  const factory PersonEvent.editedPerson(bool? personEdited) = _EditedEvent;
  const factory PersonEvent.orderClicked(ProductOrder productOrder, bool clickAllowed) = _OrderClickedEvent;
  const factory PersonEvent.commentEdited(String? content, int? commentId) = _CommentEditedEvent;
  const factory PersonEvent.commentStatusChanged(Comment comment, bool newValue) = _CommentStatusChangedEvent;
  const factory PersonEvent.resetOrder(ProductOrder productOrder, bool? shouldReset) = _ResetOrderEvent;
  const factory PersonEvent.deletePerson(bool? shouldDelete) = _DeletePersonEvent;
}
