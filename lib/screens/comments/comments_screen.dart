import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../until/date_time_ext.dart';
import 'bloc/comments_bloc.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentsBloc _commentsBloc;

  @override
  void initState() {
    _commentsBloc = CommentsBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _commentsBloc.add(SelectStatusEvent(0)); // 0 = isOpen
    });
    super.initState();
  }

  @override
  void dispose() {
    _commentsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
        bloc: _commentsBloc,
        builder: (context, state) {
          return state is CommentsLoadedState
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildToggleButtons(context, state),
                        buildTable(context, state)
                      ]),
                )
              : Container();
        });
  }

  Widget buildToggleButtons(BuildContext context, CommentsLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.centerRight,
          child: ToggleButtons(
            onPressed: (index) => _commentsBloc.add(SelectStatusEvent(index)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            isSelected: state.selectedStatus,
            children: const [Text('Offen'), Text('Erledigt')],
          )),
    );
  }

  static const EdgeInsetsGeometry _tableCellPadding = EdgeInsets.all(8);
  static const TextStyle _headerStyle =
      TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
  static const TableRow _headerRow = TableRow(children: [
    Padding(
        padding: _tableCellPadding, child: Text('Datum', style: _headerStyle)),
    Padding(
      padding: _tableCellPadding,
      child: Text('Kommentar', style: _headerStyle),
    )
  ]);

  Widget buildTable(BuildContext context, CommentsLoadedState state) {
    if (state.comments.isEmpty) {
      return const Center(child: Text('Keine Einträge vorhanden'));
    }

    final contentRows = state.comments.map((item) => TableRow(children: [
          TableCell(
              child: TableRowInkWell(
            onTap: () => goToOrder(item.personId),
            child: Padding(
                padding: _tableCellPadding,
                child: Text(item.issuedDate.toCalendarDate())),
          )),
          TableCell(
              child: TableRowInkWell(
            onTap: () => goToOrder(item.personId),
            child:
                Padding(padding: _tableCellPadding, child: Text(item.content)),
          ))
        ]));

    return Flexible(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              border: TableBorder.symmetric(
                  inside: const BorderSide(
                      style: BorderStyle.solid, color: Colors.grey)),
              columnWidths: const <int, TableColumnWidth>{
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth()
              },
              children: [
                _headerRow,
                ...contentRows,
              ],
            )));
  }

  void goToOrder(int personId) {
    // TODO
    // Navigator.pushNamed(context, '/person');
  }
}
