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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
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
                      itemCount: state.names.length,
                      itemBuilder: (context, index) {
                        return Text(state.names[index]);
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    )
                  ],
                ),
              ),
            );
          }
          return Container();
        }
      )
    );
  }
}