import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_text_dialog_bloc.freezed.dart';

part 'edit_text_dialog_event.dart';

part 'edit_text_dialog_state.dart';

class EditTextDialogBloc
    extends Bloc<EditTextDialogEvent, EditTextDialogState> {
  EditTextDialogBloc() : super(const EditTextDialogState()) {
    on<EditTextDialogEvent>((event, emit) async {
      await event.when(
        setText: (content) async {
          emit(EditTextDialogState(
            status: EditTextDialogStatus.edit,
            content: content,
          ));
        },
        updateContent: (content) async =>
            emit(state.copyWith(content: content)),
        cancel: () async =>
            emit(state.copyWith(status: EditTextDialogStatus.cancel)),
        save: () async {
          emit(state.copyWith(status: EditTextDialogStatus.save));
        },
      );
    });
  }
}
