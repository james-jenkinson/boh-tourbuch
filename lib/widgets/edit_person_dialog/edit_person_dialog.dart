import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../until/date_time_ext.dart';
import 'bloc/edit_person_dialog_bloc.dart';

class EditPersonDialog extends StatefulWidget {
  final Person person;

  const EditPersonDialog({super.key, required this.person});

  @override
  State<EditPersonDialog> createState() => _EditPersonDialogState();

  static Future<Person?> open(BuildContext context, Person person) async {
    return showDialog<Person>(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditPersonDialog(person: person));
  }
}

class _EditPersonDialogState extends State<EditPersonDialog> {
  late EditPersonDialogBloc _editPersonDialogBloc;

  @override
  void initState() {
    _editPersonDialogBloc = EditPersonDialogBloc(widget.person);
    super.initState();
  }

  @override
  void dispose() {
    _editPersonDialogBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocConsumer<EditPersonDialogBloc, EditPersonDialogState>(
        bloc: _editPersonDialogBloc,
        listener: (context, state) {
          if (state is CloseDialogState) {
            Navigator.pop(context, state.person);
          }
        },
        builder: (context, state) {
          if (state is EditPersonDialogInitialState) {
            final blockedSince = state.blockedSince;
            return AlertDialog(
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
                        controller: _editPersonDialogBloc.name,
                        maxLength: 50,
                        decoration: const InputDecoration(labelText: 'Name'),
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name darf nicht leer sein!';
                          }
                          return null;
                        },
                      ),
                      ListTileTheme(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0.0,
                        child: CheckboxListTile(
                            // visualDensity:
                            //     VisualDensity(horizontal: -4, vertical: 0),
                            title: blockedSince != null
                                ? Text(
                                    'Gesperrt seit ${blockedSince.toCalendarDate()}')
                                : const Text('Gesperrt'),
                            value: blockedSince != null,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) => _editPersonDialogBloc.add(
                                BlockedStatusChangedEvent(
                                    formKey.currentState?.validate()))),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                          child: TextFormField(
                            controller: _editPersonDialogBloc.comment,
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
                  onChanged: () => _editPersonDialogBloc
                      .add(FormChangedEvent(formKey.currentState?.validate())),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () =>
                        _editPersonDialogBloc.add(CancelClickedEvent()),
                    child: const Text('Abbrechen')),
                ElevatedButton(
                    onPressed: state.formValid
                        ? () => _editPersonDialogBloc.add(SaveClickedEvent())
                        : null,
                    child: const Text('Speichern'))
              ],
            );
          }
          return Container();
        });
  }
}
