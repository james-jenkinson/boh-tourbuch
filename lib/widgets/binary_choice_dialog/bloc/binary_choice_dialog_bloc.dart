import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'binary_choice_dialog_bloc.freezed.dart';

part 'binary_choice_dialog_event.dart';

part 'binary_choice_dialog_state.dart';

class BinaryChoiceDialogBloc
    extends Bloc<BinaryChoiceDialogEvent, BinaryChoiceDialogState> {
  BinaryChoiceDialogBloc() : super(const BinaryChoiceDialogState()) {
    on<BinaryChoiceDialogEvent>((event, emit) async {
      await event.when(
        cancel: () async =>
            emit(state.copyWith(status: BinaryChoiceDialogStatus.cancel)),
        save: () async {
          emit(state.copyWith(status: BinaryChoiceDialogStatus.save));
        },
      );
    });
  }
}
