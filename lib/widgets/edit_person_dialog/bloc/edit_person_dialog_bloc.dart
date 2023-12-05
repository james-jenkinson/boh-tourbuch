import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/person.dart';
import '../../../repository/person_repository.dart';
import '../../../until/date_time_ext.dart';

part 'edit_person_dialog_bloc.freezed.dart';

part 'edit_person_dialog_event.dart';

part 'edit_person_dialog_state.dart';

class EditPersonDialogBloc
    extends Bloc<EditPersonDialogEvent, EditPersonDialogState> {
  final PersonRepository _personRepository;

  EditPersonDialogBloc(this._personRepository)
      : super(const EditPersonDialogState()) {
    on<EditPersonDialogEvent>((event, emit) async {
      await event.when(
        setPerson: (person, personToMerge) async {
          emit(EditPersonDialogState(
            status: EditPersonDialogStatus.edit,
            id: person.id,
            name: person.name +
                (personToMerge == null ? '' : ' / ${personToMerge.name}'),
            blockedSince:
                minDateTime(person.blockedSince, personToMerge?.blockedSince),
            comment: personToMerge == null
                ? person.comment
                : person.comment.isEmpty || personToMerge.comment.isEmpty
                    // one or both are empty => concat is OK
                    ? person.comment + personToMerge.comment
                    : '${person.comment} / ${personToMerge.comment}',
            personToMerge: personToMerge,
          ));
        },
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

          final personToMerge = state.personToMerge;
          if (personToMerge == null) {
            await _personRepository.updatePerson(person);
          } else {
            await _personRepository.mergePersons(person, personToMerge);
          }

          emit(state.copyWith(status: EditPersonDialogStatus.save));
        },
      );
    });
  }
}
