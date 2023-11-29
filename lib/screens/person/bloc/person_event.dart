part of 'person_bloc.dart';

@immutable
abstract class PersonEvent {}

class PersonInitialEvent extends PersonEvent {
  final Person selectedPerson;

  PersonInitialEvent(this.selectedPerson);
}

class PersonEditedEvent extends PersonEvent {
  final bool? personEdited;

  PersonEditedEvent(this.personEdited);
}

class ProductOrderClickedEvent extends PersonEvent {
  final ProductOrder productOrder;
  final bool clickAllowed;

  ProductOrderClickedEvent(
      {required this.productOrder, required this.clickAllowed});
}

class CommentEditedEvent extends PersonEvent {
  final String? content;
  final int? commentId;

  CommentEditedEvent(this.content, this.commentId);
}

class CommentStatusChangedEvent extends PersonEvent {
  final Comment comment;
  final bool newValue;

  CommentStatusChangedEvent(this.comment, this.newValue);
}
