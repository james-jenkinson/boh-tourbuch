import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../until/date_time_ext.dart';
import 'bloc/new_order_bloc.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  late NewOrderBloc _newOrderBloc;

  @override
  void initState() {
    _newOrderBloc = NewOrderBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _newOrderBloc.add(NewOrderInitialEvent(
          ModalRoute.of(context)!.settings.arguments as Person));
    });
    super.initState();
  }

  @override
  void dispose() {
    _newOrderBloc.close();
    super.dispose();
  }

  static const TextStyle defaultTextStyle =
      TextStyle(fontSize: 30, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderBloc, NewOrderState>(
        bloc: _newOrderBloc,
        listener: (context, state) {
          if (state is NewOrderSavedState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is NewOrderInitialState) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (state is NewOrderUpdatedState) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Neue Bestellung'),
                ),
                body: DefaultTextStyle.merge(
                  style: defaultTextStyle,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextField(
                                  style: defaultTextStyle,
                                  controller:
                                      _newOrderBloc.textEditingControllerDate,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                      icon: Icon(
                                        Icons.edit_calendar,
                                        size: 30,
                                      ),
                                      enabledBorder: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder()),
                                  onTap: () => showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now()
                                            .subtract(const Duration(days: 10)),
                                        lastDate: DateTime.now()
                                            .add(const Duration(days: 10)),
                                      ).then((value) {
                                        if (value != null) {
                                          _newOrderBloc
                                              .textEditingControllerDate
                                              .text = value.toCalendarDate();
                                        }
                                      })),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _newOrderBloc.add(NewOrderSaveEvent());
                                },
                                child: const Text('Speichern',
                                    style: TextStyle(fontSize: 30))),
                          ],
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 100,
                                mainAxisSpacing: 20,
                                childAspectRatio: 3,
                                children: state.productTypes.map((type) {
                                  return GestureDetector(
                                    onTap: () {
                                      _newOrderBloc.add(
                                          NewOrderProductSelectionChangedEvent(
                                              type.$1));
                                    },
                                    child: Container(
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 40),
                                              Text(type.$1.symbol),
                                              const SizedBox(width: 40),
                                              Text(
                                                  '${type.$1.name} (${type.$2 ? 'bestellt' : 'nicht bestellt'})')
                                            ],
                                          ),
                                        )),
                                  );
                                }).toList()),
                          ),
                        ),
                        TextField(
                          controller:
                              _newOrderBloc.textEditingControllerComment,
                          style: defaultTextStyle,
                          decoration: const InputDecoration(
                              hintText: 'Kommentar',
                              enabledBorder: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder()),
                          showCursor: true,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                        )
                      ],
                    ),
                  ),
                ));
          }
          return Container();
        });
  }
}
