import 'package:flutter/material.dart';

import '../models/person.dart';

class PersonText extends StatelessWidget {
  final Person person;
  final TextStyle? style;

  const PersonText({super.key, required this.person, this.style});

  @override
  Widget build(BuildContext context) {
    final blockedSince = person.blockedSince;
    return Row(
      children: [
        Text(
          person.name,
          style: style,
        ),
        Visibility(
          visible: blockedSince != null,
          child: const Icon(Icons.lock, size: 18,),
        )
      ],
    );
  }
}
