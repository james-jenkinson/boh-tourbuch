import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/edit_text_dialog_bloc.dart';

class EditTextDialog extends StatefulWidget {
  final String content;

  const EditTextDialog({super.key, required this.content});

  @override
  State<EditTextDialog> createState() => _EditTextDialogState();

  static Future<String?> open(BuildContext context, String content) async {
    return showDialog<String?>(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditTextDialog(content: content));
  }
}

class _EditTextDialogState extends State<EditTextDialog> {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) {
        return EditTextDialogBloc()
          ..add(EditTextDialogEvent.setText(widget.content));
      },
      child: Builder(
          builder: (context) =>
              BlocConsumer<EditTextDialogBloc, EditTextDialogState>(
                  bloc: context.read<EditTextDialogBloc>(),
                  listener: (context, state) {
                    switch (state.status) {
                      case EditTextDialogStatus.save:
                        return Navigator.pop(context, state.content);
                      case EditTextDialogStatus.cancel:
                        return Navigator.pop(context, null);
                      default:
                        break;
                    }
                  },
                  builder: (context, state) {
                    final addEvent = context.read<EditTextDialogBloc>().add;

                    switch (state.status) {
                      case EditTextDialogStatus.edit:
                        return buildEdit(addEvent, state);
                      default:
                        return const CircularProgressIndicator();
                    }
                  })),
    );
  }

  Widget buildEdit(
      void Function(EditTextDialogEvent) addEvent, EditTextDialogState state) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      title: const Center(child: Text('Bearbeiten')),
      content: SizedBox(
        width: 450,
        child: TextFormField(
          autofocus: true,
          initialValue: state.content,
          onChanged: (value) =>
              addEvent(EditTextDialogEvent.updateContent(value)),
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
      actions: [
        TextButton(
            onPressed: () => addEvent(const EditTextDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: () => addEvent(const EditTextDialogEvent.save()),
            child: const Text('Speichern'))
      ],
    );
  }
}
