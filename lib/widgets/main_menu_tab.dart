import 'package:flutter/material.dart';

class MainMenuTab extends StatelessWidget {
  final String title;
  final IconData iconData;

  const MainMenuTab({super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(iconData), const SizedBox(width: 10), Text(title)],
    ));
  }
}
