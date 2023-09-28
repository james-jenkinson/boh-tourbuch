import 'package:boh_tourbuch/screens/faq/bloc/faq_bloc.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
