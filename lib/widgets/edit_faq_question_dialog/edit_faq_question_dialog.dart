import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/faq_question.dart';
import 'bloc/edit_faq_question_dialog_bloc.dart';

class EditFAQQuestionDialog extends StatefulWidget {
  final FAQQuestion? faqQuestion;

  const EditFAQQuestionDialog({super.key, this.faqQuestion});

  @override
  State<EditFAQQuestionDialog> createState() => _EditFAQQuestionDialogState();
}

class _EditFAQQuestionDialogState extends State<EditFAQQuestionDialog> {
  late EditFAQQuestionDialogBloc _editFAQQuestionDialogBloc;

  _EditFAQQuestionDialogState();

  @override
  void initState() {
    _editFAQQuestionDialogBloc = EditFAQQuestionDialogBloc(widget.faqQuestion);
    super.initState();
  }

  @override
  void dispose() {
    _editFAQQuestionDialogBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocConsumer(
        listener: (context, state) {
          if (state is ClosedDialog) {
            Navigator.pop(context, state.saveClicked);
          }
        },
        bloc: _editFAQQuestionDialogBloc,
        builder: (context, state) {
          if (state is EditFAQQuestionDialogInitial) {
            return AlertDialog(
              titlePadding: const EdgeInsets.all(10),
              actionsPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                  'Frage ${state.faqQuestion == null ? 'hinzufügen' : 'bearbeiten'}'),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _editFAQQuestionDialogBloc.question,
                            autovalidateMode: AutovalidateMode.disabled,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              labelText: 'Frage',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte Feld ausfüllen.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            minLines: 4,
                            maxLength: 10000,
                            maxLines: null,
                            controller: _editFAQQuestionDialogBloc.answer,
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: const InputDecoration(
                              labelText: 'Antwort',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte Feld ausfüllen.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      onChanged: () => _editFAQQuestionDialogBloc
                          .add(FormChangedEvent(formKey.currentState?.validate())),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () =>
                    _editFAQQuestionDialogBloc.add(CancelClickedEvent()),
                    child: const Text('Abbrechen')),
                ElevatedButton(
                    onPressed: state.validate
                        ? () =>
                        _editFAQQuestionDialogBloc.add(SaveClickedEvent())
                        : null,
                    child: const Text('Speichern'))
              ],
            );
          }
          return Container();
        });
  }
}
