import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/person.dart';
import '../../../repository/person_repository.dart';

part 'edit_person_dialog_bloc.freezed.dart';

part 'edit_person_dialog_event.dart';

part 'edit_person_dialog_state.dart';

class EditPersonDialogBloc
    extends Bloc<EditPersonDialogEvent, EditPersonDialogState> {
  final PersonRepository _personRepository;

  EditPersonDialogBloc(this._personRepository) : super(const EditPersonDialogState()) {
    on<EditPersonDialogEvent>((event, emit) async {
      await event.when(
        setPerson: (person) async => emit(EditPersonDialogState(
            status: EditPersonDialogStatus.edit,
            id: person.id,
            name: person.name,
            blockedSince: person.blockedSince,
            comment: person.comment,
          )),
        updateName: (name) async => emit(state.copyWith(name: name)),
        updateBlocked: (blocked) async =>
            emit(state.copyWith(blockedSince: blocked ? DateTime.now() : null)),
        updateComment: (comment) async =>
            emit(state.copyWith(comment: comment)),
        cancel: () async =>
            emit(state.copyWith(status: EditPersonDialogStatus.cancel)),
        save: () async {
          final person = Person(
            id: state.id,
            name: state.name,
            blockedSince: state.blockedSince,
            comment: state.comment,
          );
          await _personRepository.updatePerson(person);
          emit(state.copyWith(status: EditPersonDialogStatus.save));
        },
      );
    });
  }
}
