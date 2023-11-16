part of 'comments_bloc.dart';

@immutable
abstract class CommentsEvent {}

class SelectStatusEvent extends CommentsEvent {
  /// index 0 = open
  /// index 1 = closed
  final int selectedIndex;

  SelectStatusEvent(this.selectedIndex);
}