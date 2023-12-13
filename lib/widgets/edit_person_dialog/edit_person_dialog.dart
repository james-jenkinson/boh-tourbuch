import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../repository/person_repository.dart';
import '../../until/date_time_ext.dart';
import 'bloc/edit_person_dialog_bloc.dart';

class EditPersonDialog extends StatefulWidget {
  final Person person;
  final Person? personToMerge;

  const EditPersonDialog({super.key, required this.person, this.personToMerge});

  @override
  State<EditPersonDialog> createState() => _EditPersonDialogState();

  static Future<bool?> open(
      BuildContext context, Person person, Person? personToMerge) async {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) =>
            EditPersonDialog(person: person, personToMerge: personToMerge));
  }
}

class _EditPersonDialogState extends State<EditPersonDialog> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) => EditPersonDialogBloc(PersonRepository())
        ..add(EditPersonDialogEvent.setPerson(widget.person, widget.personToMerge)),
      child: Builder(
          builder: (context) =>
              BlocConsumer<EditPersonDialogBloc, EditPersonDialogState>(
                  bloc: context.read<EditPersonDialogBloc>(),
                  listener: (context, state) {
                    switch (state.status) {
                      case EditPersonDialogStatus.save:
                        return Navigator.pop(context, true);
                      case EditPersonDialogStatus.cancel:
                        return Navigator.pop(context, false);
                      default:
                      // nothing to do
                    }
                  },
                  builder: (context, state) {
                    final addEvent = context.read<EditPersonDialogBloc>().add;

                    switch (state.status) {
                      case EditPersonDialogStatus.edit:
                        return buildEdit(addEvent, state);
                      default:
                        return const CircularProgressIndicator();
                    }
                  })),
    );
  }

  Widget buildEdit(void Function(EditPersonDialogEvent) addEvent,
      EditPersonDialogState state) {
    final blockedSince = state.blockedSince;
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      title: const Center(child: Text('Gast bearbeiten')),
      content: SizedBox(
        width: 450,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: state.name,
                maxLength: 50,
                decoration: const InputDecoration(labelText: 'Name'),
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name darf nicht leer sein!';
                  }
                  return null;
                },
                onChanged: (value) =>
                    addEvent(EditPersonDialogEvent.updateName(value)),
              ),
              ListTileTheme(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0.0,
                child: CheckboxListTile(
                    title: blockedSince != null
                        ? Text('Gesperrt seit ${blockedSince.toCalendarDate()}')
                        : const Text('Gesperrt'),
                    value: blockedSince != null,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) => addEvent(
                        EditPersonDialogEvent.updateBlocked(value == true))),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                  child: TextFormField(
                    initialValue: state.comment,
                    onChanged: (value) =>
                        addEvent(EditPersonDialogEvent.updateComment(value)),
                    maxLength: 500,
                    minLines: 1,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        labelText: 'Kommentar',
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder()),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => addEvent(const EditPersonDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: formKey.currentState?.validate() == true
                ? () => addEvent(const EditPersonDialogEvent.save())
                : null,
            child: const Text('Speichern'))
      ],
    );
  }
}
