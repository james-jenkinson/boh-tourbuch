import 'package:boh_tourbuch/models/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<OrdersBloc, OrdersState>(
        bloc: _ordersBloc,
        builder: (context, state) {
          if (state is OrdersInitial) {
            return getScaffold(
                const Center(child: CircularProgressIndicator()));
          } else if (state is OrdersLoaded) {
            return getScaffold(Center(
                child: Column(
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    '${state.selectedPerson.firstName} ${state.selectedPerson.lastName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit))
                ]),
                const SizedBox(height: 10),
                Expanded(
                    child: Row(children: [
                  Expanded(
                    flex: 1,
                      child: Column(children: [
                    const Text("Letzte Bestellungen"),
                    const SizedBox(height: 10),
                    Expanded(child: ListView.builder(
                      itemCount: state.orders.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              state.orders[index].orderDate.toIso8601String()),
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
