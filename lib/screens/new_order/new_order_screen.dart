import 'package:boh_tourbuch/screens/new_order/bloc/new_order_bloc.dart';
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
    WidgetsBinding.instance.addPersistentFrameCallback((_) async {
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocBuilder<NewOrderBloc, NewOrderState>(
          bloc: _newOrderBloc,
          builder: (context, state) {
            if (state is NewOrderInitialState) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            } else if (state is NewOrderPersonLoaded) {
              return Scaffold(
                  body: Column(
                children: [
                  Center(child: Text(state.selectedPerson.firstName)),
                ],
              ));
            }
            return Container();
          }),
    );
  }
}
