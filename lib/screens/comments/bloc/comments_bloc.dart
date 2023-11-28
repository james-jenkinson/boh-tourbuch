import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/comment.dart';
import '../../../repository/comment_repository.dart';

part 'comments_event.dart';

part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentRepository _commentRepository = CommentRepository();

  bool _selectedStatusOpen = true;

  CommentsBloc() : super(CommentsInitialState()) {
    on<CommentsEvent>((event, emit) async {
      if (event is SelectStatusEvent) {
        selectNewStatus(event.selectedIndex);
        emit(await createCommentsLoadedState());
      }
    });
  }

  /// index 0 = open
  /// index 1 = closed
  void selectNewStatus(int selectedIndex) {
    _selectedStatusOpen = selectedIndex == 0;
  }

  Future<CommentsLoadedState> createCommentsLoadedState() async {
    return CommentsLoadedState(
        await _commentRepository.getAllCommentsByStatus(_selectedStatusOpen), [
      _selectedStatusOpen,
      !_selectedStatusOpen,
    ]);
  }
}
