import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/faq_bloc.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: BlocProvider<FaqBloc>(
        create: (_) => FaqBloc()..add(const FaqEvent.loadData()),
        child: BlocBuilder<FaqBloc, FaqState>(
          builder: (context, state) {
            switch (state.status) {
              case FaqScreenStatus.initial:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case FaqScreenStatus.data:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: ExpansionPanelList.radio(
                      materialGapSize: 1,
                      children: state.faqQuestions
                          .asMap()
                          .entries
                          .map((q) => ExpansionPanelRadio(
                              value: q.key,
                              canTapOnHeader: true,
                              headerBuilder: (context, isOpen) => ListTile(
                                      title: Text(
                                    q.value.question,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                              body: ListTile(title: Text(q.value.answer))))
                          .toList(),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
