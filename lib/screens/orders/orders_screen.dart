import 'package:boh_tourbuch/screens/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrdersBloc _ordersBloc;

  @override
  void initState() {
    _ordersBloc = OrdersBloc()..add(OrdersListFilterEvent(""));
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrdersListChanged) {
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => _ordersBloc.add(OrdersListFilterEvent(value)),
                    ),
                    ListView.builder(
                      itemCount: state.persons.length,
                      itemBuilder: (context, index) {
                        return Text('${state.persons[index].id} : ${state.persons[index].name}');
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    ),
                    ElevatedButton(onPressed: () => _ordersBloc.add(OrdersAddPersonClickedEvent()), child: const Text('Add'))
                  ],
                ),
              ),
            );
          }
          return Container();
        }
    );
  }
}