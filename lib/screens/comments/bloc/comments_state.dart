part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {}

class CommentsInitialState extends CommentsState {}

class CommentsLoadedState extends CommentsState {
  final Iterable<Comment> comments;
  /// index 0: isOpen
  /// index 1: isDone
  final List<bool> selectedStatus;

  CommentsLoadedState(this.comments, this.selectedStatus);
}
