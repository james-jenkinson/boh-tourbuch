part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {}

class CommentsInitialState extends CommentsState {}

class CommentsLoadedState extends CommentsState {
  final Iterable<Order> orders;
  /// index 0: isOpen
  /// index 1: isDone
  final List<bool> selectedStatus;

  CommentsLoadedState(this.orders, this.selectedStatus);
}
