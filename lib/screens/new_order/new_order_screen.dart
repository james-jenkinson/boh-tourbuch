import 'package:boh_tourbuch/screens/new_order/bloc/new_order_bloc.dart';
import 'package:boh_tourbuch/widgets/person_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  late NewOrderBloc _newOrderBloc;

  @override
  void initState() {
    _newOrderBloc = NewOrderBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _newOrderBloc.add(NewOrderInitialEvent(
          ModalRoute.of(context)!.settings.arguments as Person));
    });
    super.initState();
  }

  @override
  void dispose() {
    _newOrderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewOrderBloc, NewOrderState>(
        bloc: _newOrderBloc,
        builder: (context, state) {
          if (state is NewOrderInitialState) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is NewOrderPersonLoaded) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Neue Bestellung'),
                ),
                body: Column(
                  children: [
                    Center(
                        child: PersonText(
                            person: state.selectedPerson,
                            style: const TextStyle(fontSize: 24)))
                  ],
                ));
          }
          return Container();
        });
  }
}
