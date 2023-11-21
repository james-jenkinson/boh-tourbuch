import 'package:flutter/material.dart';

import '../models/person.dart';
import '../until/date_time_ext.dart';

class PersonText extends StatelessWidget {
  final Person person;
  final TextStyle? style;

  const PersonText({super.key, required this.person, this.style});

  @override
  Widget build(BuildContext context) {
    final blockedSince = person.blockedSince;
    return blockedSince != null
        ? Text('${person.name} (${blockedSince.toCalendarDate()})',
            style: (style ?? const TextStyle()).copyWith(color: Colors.red))
        : Text(person.name, style: style);
  }
}
