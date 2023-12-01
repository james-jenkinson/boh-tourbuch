part of 'comment_bloc.dart';

enum CommentScreenState { initial, data, navigateToPerson }

@freezed
class CommentState with _$CommentState {
  const factory CommentState(
      {@Default(CommentScreenState.initial) CommentScreenState status,
      @Default([true, false]) List<bool> selected, // index 0: isOpen, index 1: isDone
      @Default(null) Person? selectedPerson,
      @Default([]) List<CommentWithPerson> commentsWithPerson}) = _CommentState;
}
