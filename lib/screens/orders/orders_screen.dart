import 'package:boh_tourbuch/screens/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';

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