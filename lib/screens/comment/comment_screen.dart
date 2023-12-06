import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/comment_repository.dart';
import '../../repository/person_repository.dart';
import '../../until/date_time_ext.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/comment_bloc.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentBloc(CommentRepository(), PersonRepository())
        ..add(const CommentEvent.initial()),
      child: BlocConsumer<CommentBloc, CommentState>(
        listener: (context, state) async {
          switch (state.status) {
            case CommentScreenState.navigateToPerson:
              await Navigator.pushNamed(context, '/person',
                      arguments: state.selectedPerson)
                  .then((value) => context
                      .read<CommentBloc>()
                      .add(const CommentEvent.initial()));
            default:
          }
        },
        builder: (BuildContext context, CommentState state) {
          final CommentBloc commentBloc = context.read<CommentBloc>();
          switch (state.status) {
            case CommentScreenState.navigateToPerson:
            case CommentScreenState.initial:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case CommentScreenState.data:
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildToggleButtons(state.selected, commentBloc.add),
                      Expanded(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: constraints.maxWidth),
                                    child: buildDataTable(
                                        state, commentBloc.add))),
                          );
                        }),
                      )
                    ]),
              );
          }
        },
      ),
    );
  }

  Widget buildToggleButtons(
    List<bool> selected,
    void Function(CommentEvent) addEvent,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.centerRight,
          child: ToggleButtons(
            onPressed: (index) => addEvent(CommentEvent.filterComments(index)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: selected,
            children: const [Text('Offen'), Text('Erledigt')],
          )),
    );
  }

  DataTable buildDataTable(
      CommentState state, void Function(CommentEvent) addEvent) {
    return DataTable(
        showCheckboxColumn: false,
        dataRowMaxHeight: double.infinity,
        columns: const [
          DataColumn(label: Text('Datum')),
          DataColumn(label: Text('Kommentar')),
          DataColumn(label: Text('Name')),
        ],
        rows: state.commentsWithPerson
            .map((commentWithPerson) => DataRow(
                    onSelectChanged: (selected) => addEvent(
                        CommentEvent.navigatePerson(commentWithPerson.person)),
                    cells: [
                      DataCell(Text(
                        commentWithPerson.comment.issuedDate.toCalendarDate(),
                      )),
                      DataCell(
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            commentWithPerson.comment.content,
                            maxLines: 4,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                      DataCell(PersonText(person: commentWithPerson.person)),
                    ]))
            .toList());
  }
}
