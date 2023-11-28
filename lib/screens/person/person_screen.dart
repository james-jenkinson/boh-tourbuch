import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../models/product_order.dart';
import '../../widgets/edit_comment_dialog/edit_comment_dialog.dart';
import '../../widgets/edit_person_dialog/edit_person_dialog.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/person_bloc.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  late PersonBloc _personBloc;

  @override
  void initState() {
    _personBloc = PersonBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _personBloc.add(PersonInitialEvent(
          ModalRoute.of(context)!.settings.arguments as Person));
    });
    super.initState();
  }

  @override
  void dispose() {
    _personBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonBloc, PersonState>(
        bloc: _personBloc,
        builder: (context, state) {
          if (state is PersonInitial) {
            return Scaffold(
                appBar: getAppBar(), body: const CircularProgressIndicator());
          } else if (state is PersonLoaded) {
            return Scaffold(
                appBar: getAppBar(),
                floatingActionButton: FloatingActionButton.large(
                    onPressed: () async => _personBloc.add(CommentEditedEvent(
                          await EditCommentDialog.open(context, ''),
                          null,
                        )),
                    child: const Icon(Icons.add)),
                body: Center(
                    child: Column(
                  children: [
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      PersonText(
                        person: state.selectedPerson,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      IconButton(
                          onPressed: () async => _personBloc.add(
                              PersonEditedEvent(await EditPersonDialog.open(
                                  context, state.selectedPerson))),
                          icon: const Icon(Icons.edit))
                    ]),
                    Flexible(
                      child: CustomScrollView(shrinkWrap: false, slivers: [
                        SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 50,
                              mainAxisSpacing: 20,
                              childAspectRatio: 3,
                            ),
                            delegate: SliverChildListDelegate([
                              ...state.productOrdersWithSymbols
                                  .map((productOrder) {
                                return GestureDetector(
                                  onTap: () {
                                    _personBloc.add(ProductOrderClickedEvent(
                                        productOrder: productOrder,
                                        clickType: ClickType.shortTap));
                                  },
                                  onLongPress: () {
                                    _personBloc.add(ProductOrderClickedEvent(
                                        productOrder: productOrder,
                                        clickType: ClickType.longTap));
                                  },
                                  child: Card(
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(width: 40),
                                            Text(productOrder.symbol),
                                            const SizedBox(width: 40),
                                            Visibility(
                                                visible: productOrder.status ==
                                                    OrderStatus.notOrdered,
                                                child: Column(children: [
                                                  Text(productOrder.name),
                                                  const Text('Nicht bestellt'),
                                                ])),
                                            Visibility(
                                                visible: productOrder.status ==
                                                    OrderStatus.ordered,
                                                child: Column(children: [
                                                  Text(productOrder.name),
                                                  Text(
                                                      'Bestellt am ${productOrder.lastIssueDate}'),
                                                ])),
                                            Visibility(
                                                visible: productOrder.status ==
                                                    OrderStatus.received,
                                                child: Column(children: [
                                                  Text(productOrder.name),
                                                  Text(
                                                      'Erhalten am ${productOrder.lastReceivedDate}'),
                                                ])),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                              // comment list
                            ])),
                        const SliverPadding(
                            padding: EdgeInsets.all(10),
                            sliver:
                                SliverToBoxAdapter(child: Divider(height: 10))),
                        SliverList.list(
                            children: state.comments
                                .map(
                                  (comment) => CheckboxListTile(
                                    secondary: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async => _personBloc.add(
                                          CommentEditedEvent(
                                              await EditCommentDialog.open(
                                                  context, comment.content),
                                              comment.id)),
                                    ),
                                    title: Text(
                                      comment.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: comment.commentDone,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        _personBloc.add(
                                            CommentStatusChangedEvent(
                                                comment, value));
                                      }
                                    },
                                  ),
                                )
                                .toList())
                      ]),
                    )
                  ],
                )));
          }
          return Scaffold(appBar: getAppBar(), body: Container());
        });
  }

  AppBar getAppBar() {
    return AppBar(title: const Text('Bestellungen'));
  }
}
