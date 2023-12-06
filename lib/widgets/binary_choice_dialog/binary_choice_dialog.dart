import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/binary_choice_dialog_bloc.dart';

class BinaryChoiceDialog extends StatefulWidget {
  final String title;
  final String content;

  const BinaryChoiceDialog({super.key, required this.content, required this.title});

  @override
  State<BinaryChoiceDialog> createState() => _BinaryChoiceDialogState();

  static Future<bool?> open(BuildContext context, String title, String content) async {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => BinaryChoiceDialog(content: content, title: title,));
  }
}

class _BinaryChoiceDialogState extends State<BinaryChoiceDialog> {

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) {
        return BinaryChoiceDialogBloc();
      },
      child: Builder(
          builder: (context) =>
              BlocConsumer<BinaryChoiceDialogBloc, BinaryChoiceDialogState>(
                  bloc: context.read<BinaryChoiceDialogBloc>(),
                  listener: (context, state) {
                    switch (state.status) {
                      case BinaryChoiceDialogStatus.save:
                        return Navigator.pop(context, true);
                      case BinaryChoiceDialogStatus.cancel:
                        return Navigator.pop(context, false);
                      default:
                        break;
                    }
                  },
                  builder: (context, state) {
                    final addEvent = context.read<BinaryChoiceDialogBloc>().add;

                    switch (state.status) {
                      case BinaryChoiceDialogStatus.initial:
                        return buildEdit(addEvent, widget.title, widget.content);
                      default:
                        return const SizedBox.shrink();
                    }
                  })),
    );
  }

  Widget buildEdit(
      void Function(BinaryChoiceDialogEvent) addEvent, String title, String textContent) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 450,
        child: Text(textContent),
      ),
      actions: [
        TextButton(
            onPressed: () => addEvent(const BinaryChoiceDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: () => addEvent(const BinaryChoiceDialogEvent.save()),
            child: const Text('Weiter'))
      ],
    );
  }
}
