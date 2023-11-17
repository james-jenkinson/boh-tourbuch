import 'package:flutter/material.dart';

import 'bloc/faq_bloc.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late FaqBloc _faqBloc;

  @override
  void initState() {
    _faqBloc = FaqBloc();
    super.initState();
  }

  @override
  void dispose() {
    _faqBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const List<(String, String)> questions = [
      ('Warum ist die Banane krumm?', 'Lorem Ipsum'),
      ('Warum ist die Banane krumm? 2', 'Lorem Ipsum 2'),
      ('Warum ist die Banane krumm? 3', 'Lorem Ipsum 3')
    ];

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              ExpansionPanelList.radio(
                materialGapSize: 1,
                children: questions
                    .asMap()
                    .entries
                    .map((q) => ExpansionPanelRadio(
                        value: q.key,
                        canTapOnHeader: true,
                        headerBuilder: (context, isOpen) {
                          return ListTile(title: Text(q.value.$1));
                        },
                        body: ListTile(title: Text(q.value.$2))))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
