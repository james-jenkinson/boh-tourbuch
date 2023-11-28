import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/edit_comment_dialog_bloc.dart';

class EditCommentDialog extends StatefulWidget {
  final String content;

  const EditCommentDialog({super.key, required this.content});

  @override
  State<EditCommentDialog> createState() => _EditCommentDialogState();

  static Future<String?> open(BuildContext context, String content) async {
    return showDialog<String?>(
        barrierDismissible: false,
        context: context,
        builder: (context) => EditCommentDialog(content: content));
  }
}

class _EditCommentDialogState extends State<EditCommentDialog> {
  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) {
        return EditCommentDialogBloc()
          ..add(EditCommentDialogEvent.setComment(widget.content));
      },
      child: Builder(
          builder: (context) =>
              BlocConsumer<EditCommentDialogBloc, EditCommentDialogState>(
                  bloc: context.read<EditCommentDialogBloc>(),
                  listener: (context, state) {
                    switch (state.status) {
                      case EditCommentDialogStatus.save:
                        return Navigator.pop(context, state.content);
                      case EditCommentDialogStatus.cancel:
                        return Navigator.pop(context, null);
                      default:
                        break;
                    }
                  },
                  builder: (context, state) {
                    final addEvent = context.read<EditCommentDialogBloc>().add;

                    switch (state.status) {
                      case EditCommentDialogStatus.edit:
                        return buildEdit(addEvent, state);
                      default:
                        return const CircularProgressIndicator();
                    }
                  })),
    );
  }

  Widget buildEdit(void Function(EditCommentDialogEvent) addEvent,
      EditCommentDialogState state) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      actionsPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      title: const Center(child: Text('Bearbeiten')),
      content: SizedBox(
        width: 450,
        child: TextFormField(
          initialValue: state.content,
          onChanged: (value) =>
              addEvent(EditCommentDialogEvent.updateContent(value)),
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
            onPressed: () => addEvent(const EditCommentDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: () => addEvent(const EditCommentDialogEvent.save()),
            child: const Text('Speichern'))
      ],
    );
  }
}
