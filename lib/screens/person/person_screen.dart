import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/person.dart';
import '../../models/product_order.dart';
import '../../repository/comment_repository.dart';
import '../../repository/person_repository.dart';
import '../../repository/product_order_repository.dart';
import '../../repository/product_type_repository.dart';
import '../../until/date_time_ext.dart';
import '../../widgets/binary_choice_dialog/binary_choice_dialog.dart';
import '../../widgets/edit_person_dialog/edit_person_dialog.dart';
import '../../widgets/edit_text_dialog/edit_text_dialog.dart';
import '../../widgets/person_text_widget.dart';
import 'bloc/person_bloc.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedPerson = ModalRoute.of(context)!.settings.arguments as Person;
    return BlocProvider(
      create: (context) => PersonBloc(
        PersonRepository(),
        CommentRepository(),
        ProductTypeRepository(),
        ProductOrderRepository(),
        selectedPerson,
      )..add(const PersonEvent.initial()),
      child: Builder(
        builder: (context) => BlocConsumer<PersonBloc, PersonState>(
            bloc: context.read<PersonBloc>(),
            listener: (context, state) {
              switch (state.status) {
                case PersonScreenState.navigateHome:
                  Navigator.pop(context);
                default:
              }
            },
            builder: (context, state) {
              final personBloc = context.read<PersonBloc>();
              switch (state.status) {
                case PersonScreenState.initial:
                case PersonScreenState.navigateHome:
                  return Scaffold(
                    appBar: getAppBar(),
                    body: const CircularProgressIndicator(),
                  );
                case PersonScreenState.data:
                  return Scaffold(
                      appBar: getAppBarWithActions(
                          personBloc.add, state.selectedPerson),
                      floatingActionButton: FloatingActionButton.large(
                          onPressed: () async =>
                              personBloc.add(PersonEvent.commentEdited(
                                await EditTextDialog.open(context, ''),
                                null,
                              )),
                          child: const Icon(Icons.add)),
                      body: Center(
                          child: Column(
                        children: [
                          Flexible(
                            child:
                                CustomScrollView(shrinkWrap: false, slivers: [
                              SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? 2
                                            : 3,
                                    crossAxisSpacing: 50,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 3,
                                  ),
                                  delegate: SliverChildListDelegate([
                                    ...state.productOrdersWithSymbols
                                        .map((productOrder) {
                                      return Card(
                                          clipBehavior: Clip.hardEdge,
                                          child: InkWell(
                                            onTap: () async {
                                              personBloc.add(PersonEvent.orderClicked(
                                                  productOrder,
                                                  isBlockedProduct(productOrder)
                                                      ? (await BinaryChoiceDialog
                                                          .open(
                                                              context,
                                                              'Produkt gesperrt',
                                                              'Das Produkt ist für den Gast aufgrund einer kürzlichen Bestellung noch gesperrt. Soll es dennoch bestellt werden?'))!
                                                      : true));
                                            },
                                            onLongPress: () async => personBloc
                                                .add(PersonEvent.resetOrder(
                                                    productOrder,
                                                    await BinaryChoiceDialog.open(
                                                        context,
                                                        'Status zurücksetzen',
                                                        'Soll der Status von ${productOrder.name} auf \'Nicht Bestellt\' zurückgesetzt werden?'))),
                                            child: Center(
                                              child: ListTile(
                                                  leading: SizedBox(
                                                    height: 100,
                                                    child: FittedBox(
                                                        fit: BoxFit.contain,
                                                        child: Text(productOrder
                                                            .symbol)),
                                                  ),
                                                  title:
                                                      Text(productOrder.name),
                                                  subtitle: Text((() {
                                                    switch (
                                                        productOrder.status) {
                                                      case OrderStatus
                                                            .notOrdered:
                                                        return 'Nicht bestellt';
                                                      case OrderStatus.ordered:
                                                        return 'Bestellt am ${productOrder.lastIssueDate?.toCalendarDate()}';
                                                      case OrderStatus.received:
                                                        return 'Erhalten am ${productOrder.lastReceivedDate?.toCalendarDate()}';
                                                    }
                                                  })())),
                                            ),
                                          ));
                                    }),
                                    // comment list
                                  ])),
                              const SliverPadding(
                                  padding: EdgeInsets.all(10),
                                  sliver: SliverToBoxAdapter(
                                      child: Divider(height: 10))),
                              SliverList.list(
                                  children: state.comments
                                      .map(
                                        (comment) => CheckboxListTile(
                                          secondary: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async => personBloc
                                                .add(PersonEvent.commentEdited(
                                                    await EditTextDialog.open(
                                                        context,
                                                        comment.content),
                                                    comment.id)),
                                          ),
                                          title: Text(
                                            comment.content,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: comment.commentDone
                                                  ? Colors.grey
                                                  : Colors.black,
                                            ),
                                          ),
                                          value: comment.commentDone,
                                          onChanged: (bool? value) {
                                            if (value != null) {
                                              personBloc.add(PersonEvent
                                                  .commentStatusChanged(
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
            }),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(title: const Text('Bestellungen'));
  }

  AppBar getAppBarWithActions(
      void Function(PersonEvent) addEvent, Person selectedPerson) {
    return AppBar(
      title: PersonText(
        person: selectedPerson,
      ),
      actions: [
        IconButton(
            onPressed: () async => addEvent(PersonEvent.editedPerson(
                await EditPersonDialog.open(context, selectedPerson, null))),
            icon: const Icon(Icons.edit)),
        IconButton(
            onPressed: () async => addEvent(PersonEvent.deletePerson(
                await BinaryChoiceDialog.open(
                    context,
                    '${selectedPerson.name} löschen',
                    'Soll ${selectedPerson.name} gelöscht werden? Alle zugehörigen Kommentare und Bestellungen werden unwiderruflich gelöscht.'))),
            icon: const Icon(Icons.delete))
      ],
    );
  }

  bool isBlockedProduct(ProductOrderWithSymbol order) {
    return order.status == OrderStatus.received
        ? DateTime.now().isBefore(
            order.lastReceivedDate!.add(Duration(days: order.blockedPeriod)))
        : false;
  }
}
