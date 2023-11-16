part of 'comments_bloc.dart';

@immutable
abstract class CommentsState {}

class CommentsInitialState extends CommentsState {}

class CommentsLoadedState extends CommentsState {
  /// index 0: isOpen
  /// index 1: isDone
  final List<bool> selectedStatus;
  final Iterable<Order> orders;

  CommentsLoadedState(this.orders, this.selectedStatus);
}
