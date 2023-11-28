import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_comment_dialog_bloc.freezed.dart';

part 'edit_comment_dialog_event.dart';

part 'edit_comment_dialog_state.dart';

class EditCommentDialogBloc
    extends Bloc<EditCommentDialogEvent, EditCommentDialogState> {
  EditCommentDialogBloc() : super(const EditCommentDialogState()) {
    on<EditCommentDialogEvent>((event, emit) async {
      await event.when(
        setComment: (content) async {
          emit(EditCommentDialogState(
            status: EditCommentDialogStatus.edit,
            content: content,
          ));
        },
        updateContent: (content) async =>
            emit(state.copyWith(content: content)),
        cancel: () async =>
            emit(state.copyWith(status: EditCommentDialogStatus.cancel)),
        save: () async {
          emit(state.copyWith(status: EditCommentDialogStatus.save));
        },
      );
    });
  }
}
