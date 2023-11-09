import 'package:boh_tourbuch/screens/person_list/bloc/person_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  late PersonListBloc _ordersBloc;

  @override
  void initState() {
    _ordersBloc = PersonListBloc()..add(PersonListFilterEvent(''));
    super.initState();
  }

  @override
  void dispose() {
    _ordersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonListBloc, PersonListState>(
        bloc: _ordersBloc,
        listener: (context, state) {
          if (state is PersonListNavigateToOrder) {
            Navigator.pushNamed(context, '/order',
                    arguments: state.selectedPerson)
                .then((value) => _ordersBloc.add(PersonListFilterEvent('')));
          }
        },
        builder: (context, state) {
          if (state is PersonListInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is PersonListChanged) {
            return SafeArea(
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) =>
                          _ordersBloc.add(PersonListFilterEvent(value)),
                    ),
                    Expanded(child: ListView.builder(
                      itemCount: state.persons.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              '${state.persons[index].id} : ${state.persons[index].firstName} ${state.persons[index].lastName}'),
                          onTap: () => _ordersBloc.add(
                              PersonListNavigateEvent(state.persons[index])),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    )),
                    ElevatedButton(
                        onPressed: () => _ordersBloc.add(PersonListAddEvent()),
                        child: const Text('Add'))
                  ],
                ),
              ),
            );
          }
          return Container();
        });
  }
}
