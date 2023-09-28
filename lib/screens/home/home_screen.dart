import 'package:boh_tourbuch/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc();
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: BlocListener<HomeBloc, HomeState>(
          bloc: _homeBloc,
          listener: (context, state) {
            if (state is HomeNavigateOrders) {
              Navigator.pushNamed(context, "/orders");
            } else if (state is HomeNavigateFaq) {
              Navigator.pushNamed(context, "/faq");
            } else if (state is HomeNavigateComments) {
              Navigator.pushNamed(context, "/comments");
            }
          },
          child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () => _homeBloc.add(OrdersButtonClickEvent()),
                      child: const Text("Orders")),
                  ElevatedButton(
                      onPressed: () => _homeBloc.add(FaqButtonClickEvent()),
                      child: const Text("FAQ")),
                  ElevatedButton(
                      onPressed: () => _homeBloc.add(CommentsButtonClickEvent()),
                      child: const Text("Comments")),
                ],
              ),
            ),
          ),
        ));
  }
}
