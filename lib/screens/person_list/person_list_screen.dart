import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/person_text_widget.dart';
import 'bloc/person_list_bloc.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  late PersonListBloc _personListBloc;

  @override
  void initState() {
    _personListBloc = PersonListBloc()..add(PersonListFilterEvent(''));
    super.initState();
  }

  @override
  void dispose() {
    _personListBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PersonListBloc, PersonListState>(
        bloc: _personListBloc,
        listener: (context, state) {
          if (state is PersonListNavigateToOrder) {
            Navigator.pushNamed(context, '/order',
                    arguments: state.selectedPerson)
                .then((value) => _personListBloc.add(PersonListFilterEvent('')));
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
                          _personListBloc.add(PersonListFilterEvent(value)),
                    ),
                    Expanded(child: ListView.builder(
                      itemCount: state.persons.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: PersonText(person: state.persons[index]),
                          onTap: () => _personListBloc.add(
                              PersonListNavigateEvent(state.persons[index])),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                    )),
                    ElevatedButton(
                        onPressed: () => _personListBloc.add(PersonListAddEvent()),
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
