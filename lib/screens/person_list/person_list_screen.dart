import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../repository/person_repository.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/person_list_bloc.dart';

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

Future<void> navigateToPerson(BuildContext context, Person person) async {
  await Navigator.pushNamed(context, '/person', arguments: person).then(
      (value) => context
          .read<PersonListBloc>()
          .add(const PersonListEvent.loadPersons()));
}

class _PersonListScreenState extends State<PersonListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonListBloc(PersonRepository())
        ..add(const PersonListEvent.loadPersons()),
      child: Builder(
          builder: (context) => BlocConsumer<PersonListBloc, PersonListState>(
              bloc: context.read<PersonListBloc>(),
              listener: (context, state) async {
                switch (state.status) {
                  case PersonListStatus.navigateToSelected:
                    await navigateToPerson(context, state.selectedPersons[0]);
                  // TODO: Handle this case.
                  // case PersonListStatus.openMergeDialog:
                  default:
                  // nothing to do
                }
              },
              builder: (context, state) {
                switch (state.status) {
                  case PersonListStatus.initial:
                  case PersonListStatus.navigateToSelected:
                    return const Center(child: CircularProgressIndicator());
                  case PersonListStatus.data:
                    return buildList(context.read<PersonListBloc>().add, state);
                }
              })),
    );
  }

  Widget buildList(
      void Function(PersonListEvent) addEvent, PersonListState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            initialValue: state.filter,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
            onChanged: (value) => addEvent(PersonListEvent.updateFilter(value)),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: state.filteredPersons.length,
                  itemBuilder: (context, index) => ListTile(
                      title: PersonText(person: state.filteredPersons[index]),
                      onTap: () => addEvent(PersonListEvent.selectPerson(
                          state.filteredPersons[index]))),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true)),
          ElevatedButton(
              onPressed: state.filter.isEmpty
                  ? null
                  : () => addEvent(const PersonListEvent.addPerson()),
              child: const Text('Add'))
        ],
      ),
    );
  }
}
