import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String content;

  const InfoDialog({super.key, required this.content, required this.title});

  @override
  Widget build(context) {
    return Builder(
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text(title),
              content: SizedBox(
                width: 450,
                child: Text(content),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ok'))
              ],
            ));
  }

  static Future<bool?> open(
      BuildContext context, String title, String content) async {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => InfoDialog(content: content, title: title));
  }
}
