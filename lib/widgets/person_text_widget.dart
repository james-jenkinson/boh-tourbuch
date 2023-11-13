import 'package:flutter/cupertino.dart';

import '../models/person.dart';

class PersonText extends StatelessWidget {
  final Person person;
  final TextStyle? style;

  const PersonText({super.key, required this.person, this.style});

  @override
  Widget build(BuildContext context) {
    return Text('${person.firstName} ${person.lastName}', style: style);
  }
}
