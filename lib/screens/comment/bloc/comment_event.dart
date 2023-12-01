part of 'comment_bloc.dart';

@freezed
class CommentEvent with _$CommentEvent {
  const factory CommentEvent.initial() = _InitialEvent;
  const factory CommentEvent.filterComments(int selectedIndex) = _FilterCommentsEvent;// index 0: isOpen, index 1: isDone
  const factory CommentEvent.navigatePerson(Person person) = _NavigatePersonEvent;
}
