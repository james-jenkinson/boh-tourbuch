import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/person.dart';
import '../../../repository/person_repository.dart';

part 'edit_person_dialog_event.dart';
part 'edit_person_dialog_state.dart';

class EditPersonDialogBloc
    extends Bloc<EditPersonDialogEvent, EditPersonDialogState> {
  final PersonRepository _personRepository = PersonRepository();

  final Person person;

  final TextEditingController name = TextEditingController();
  final TextEditingController comment = TextEditingController();

  DateTime? _blockedSince;
  bool _formValid = false;

  EditPersonDialogBloc(this.person)
      : super(EditPersonDialogInitialState(false, person.blockedSince)) {
    _blockedSince = person.blockedSince;
    name.text = person.name;
    comment.text = person.comment;

    on<FormChangedEvent>((event, emit) {
      _formValid = event.formValid == true;
      emit(EditPersonDialogInitialState(_formValid, _blockedSince));
    });
    on<BlockedStatusChangedEvent>((event, emit) {
      _formValid = event.formValid == true;
      _blockedSince = _blockedSince == null ? DateTime.now() : null;
      // workaround, because validation check is not triggered by checkbox change
      emit(EditPersonDialogInitialState(_formValid, _blockedSince));
    });
    on<CancelClickedEvent>((event, emit) {
      emit(CloseDialogState(null));
    });
    on<SaveClickedEvent>((event, emit) async {
      final result = Person(
          id: person.id,
          name: name.text,
          blockedSince: _blockedSince,
          comment: comment.text);
      await _personRepository.updatePerson(result);

      emit(CloseDialogState(result));
    });
  }
}
