import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../until/date_time_ext.dart';
import '../../widgets/edit_person_dialog/edit_person_dialog.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/orders_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    _ordersBloc = OrdersBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _ordersBloc.add(OrdersInitialEvent(
          ModalRoute.of(context)!.settings.arguments as Person));
    });
    super.initState();
  }

  @override
  void dispose() {
    _ordersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        listener: (context, state) {
          if (state is NavigateToNewOrder) {
            Navigator.pushNamed(context, '/new_order',
                    arguments: state.selectedPerson)
                .then((value) => _ordersBloc
                    .add(NavigateBackFromNewOrderEvent(state.selectedPerson)));
          }
        },
        builder: (context, state) {
          if (state is OrdersInitial) {
            return getScaffold(
                const Center(child: CircularProgressIndicator()));
          } else if (state is OrdersLoaded) {
            return getScaffold(Center(
                child: Column(
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  PersonText(
                    person: state.selectedPerson,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(
                      onPressed: () async => _ordersBloc.add(PersonEditedEvent(
                          await EditPersonDialog.open(
                              context, state.selectedPerson))),
                      icon: const Icon(Icons.edit))
                ]),
                const SizedBox(height: 10),
                Expanded(
                    child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Column(children: [
                        const Text('Letzte Bestellungen'),
                        const SizedBox(height: 10),
                        Expanded(
                            child: ListView.builder(
                          itemCount: state.orders.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  '${state.orders[index].createDate.toCalendarDate()}: ${state.orders[index].comment}'
                              ),
                            );
                          },
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                        ))
                      ])),
                  Expanded(
                      flex: 1,
                      child: Column(children: [
                        ElevatedButton(
                            onPressed: () => _ordersBloc.add(OrdersAddEvent()),
                            child: const Text('Neue Bestellung'))
                      ]))
                ]))
              ],
            )));
          }
          return getScaffold(Container());
        });
  }

  Scaffold getScaffold(Widget body) {
    return Scaffold(
        appBar: AppBar(title: const Text('Bestellungen')), body: body);
  }
}
