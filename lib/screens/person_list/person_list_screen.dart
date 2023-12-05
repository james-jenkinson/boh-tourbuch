import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/person.dart';
import '../../repository/person_repository.dart';
import '../../widgets/edit_person_dialog/edit_person_dialog.dart';
import '../../widgets/magnify_text_widget.dart';
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
                  case PersonListStatus.editSelectedPersons:
                    await EditPersonDialog.open(
                            context,
                            state.selectedPersons[0],
                            state.selectedPersons.length > 1
                                ? state.selectedPersons[1]
                                : null)
                        .then((isSaved) => context.read<PersonListBloc>().add(
                            isSaved == true
                                ? const PersonListEvent.loadPersons()
                                : const PersonListEvent.clearSelection()));
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
                  case PersonListStatus.editSelectedPersons:
                    return buildList(context.read<PersonListBloc>().add, state);
                }
              })),
    );
  }

  List<SlidableAction> createSlideActions(
      void Function(PersonListEvent) addEvent,
      Person person,
      PersonListState state) {
    final personSelected =
        state.selectedPersons.where((item) => item.id == person.id).isNotEmpty;

    if (state.selectedPersons.isEmpty) {
      return [
        SlidableAction(
          label: 'Edit',
          icon: Icons.edit,
          onPressed: (_) =>
              addEvent(PersonListEvent.setPersonSelectedAndOpenEdit(person)),
          backgroundColor: Theme.of(context).highlightColor,
        ),
        SlidableAction(
          label: 'Select',
          icon: Icons.check_box_outline_blank,
          onPressed: (context) =>
              addEvent(PersonListEvent.togglePerson(person)),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ];
    } else {
      return [
        SlidableAction(
          label: 'Abort',
          icon: Icons.do_not_disturb,
          onPressed: (_) => addEvent(const PersonListEvent.clearSelection()),
        ),
        personSelected
            ? SlidableAction(
                label: 'Unselect',
                icon: Icons.check_box_outlined,
                onPressed: (_) =>
                    addEvent(PersonListEvent.togglePerson(person)),
                backgroundColor: Theme.of(context).secondaryHeaderColor,
              )
            : SlidableAction(
                label: 'Merge',
                icon: Icons.call_merge,
                onPressed: (_) => addEvent(
                    PersonListEvent.setPersonSelectedAndOpenEdit(person)),
                backgroundColor: Theme.of(context).primaryColor,
              ),
      ];
    }
  }

  Widget buildList(
      void Function(PersonListEvent) addEvent, PersonListState state) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: state.filter,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
                onChanged: (value) =>
                    addEvent(PersonListEvent.updateFilter(value)),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: state.filteredPersons.length,
                      itemBuilder: (context, index) {
                        final person = state.filteredPersons[index];
                        final personSelected = state.selectedPersons
                            .where((item) => item.id == person.id)
                            .isNotEmpty;

                        return Container(
                          decoration: BoxDecoration(
                              color: personSelected
                                  ? Theme.of(context).secondaryHeaderColor
                                  : null,
                              border: Border(
                                  top: BorderSide(
                                      color: Theme.of(context).dividerColor))),
                          child: Slidable(
                            startActionPane: ActionPane(
                              extentRatio: 0.2,
                              motion: const BehindMotion(),
                              children:
                                  createSlideActions(addEvent, person, state),
                            ),
                            child: ListTile(
                              title: PersonText(person: person),
                              selected: personSelected,
                              onTap: () => addEvent(
                                  PersonListEvent.navigateToPerson(person)),
                              onLongPress: () => addEvent(
                                  PersonListEvent.magnifyPerson(
                                      state.filteredPersons[index])),
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true)),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
            visible: state.filter.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FloatingActionButton.large(
                  onPressed: () => addEvent(const PersonListEvent.addPerson()),
                  child: const Icon(Icons.add)),
            ),
          ),
        ),
        state.magnifiedPerson != null
            ? MagnifyText(
                text: state.magnifiedPerson!.name,
                onClose: () =>
                    addEvent(const PersonListEvent.stopMagnifyPerson()))
            : Container(),
      ],
    );
  }
}
