import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../models/person.dart';
import '../../models/product_order.dart';
import '../../repository/comment_repository.dart';
import '../../repository/person_repository.dart';
import '../../repository/product_order_repository.dart';
import '../../repository/product_type_repository.dart';
import '../../until/date_time_ext.dart';
import '../../widgets/binary_choice_dialog/binary_choice_dialog.dart';
import '../../widgets/edit_order_dialog/edit_order_dialog.dart';
import '../../widgets/edit_person_dialog/edit_person_dialog.dart';
import '../../widgets/edit_text_dialog/edit_text_dialog.dart';
import '../../widgets/magnify_image_widget.dart';
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
                      floatingActionButton: state.magnifiedOrder == null
                          ? FloatingActionButton.large(
                              onPressed: () async =>
                                  personBloc.add(PersonEvent.commentEdited(
                                    await EditTextDialog.open(context, ''),
                                    null,
                                  )),
                              child: const Icon(Icons.add))
                          : null,
                      body: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              children: [
                                Flexible(child: scrollView(personBloc, state))
                              ],
                            ),
                          ),
                          if (state.magnifiedOrder?.image != null)
                            Material(
                                child: MagnifyImage(
                              image: Image.memory(state.magnifiedOrder!.image!),
                              onClose: () => personBloc
                                  .add(const PersonEvent.magnifyOrder(null)),
                            ))
                        ],
                      ));
              }
            }),
      ),
    );
  }

  Widget scrollView(PersonBloc bloc, PersonState state) {
    return CustomScrollView(shrinkWrap: false, slivers: [
      SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 2
                    : 3,
            crossAxisSpacing: 50,
            mainAxisSpacing: 20,
            childAspectRatio: 3,
          ),
          delegate: SliverChildListDelegate([
            ...state.productOrdersWithSymbols.map((productOrder) => Card(
                clipBehavior: Clip.hardEdge,
                child: Slidable(
                  startActionPane: ActionPane(
                      extentRatio: 0.18 * (productOrder.image != null ? 2 : 1),
                      motion: const BehindMotion(),
                      children: [
                        if (productOrder.image != null)
                          SlidableAction(
                            icon: Icons.loupe,
                            backgroundColor: Theme.of(context).primaryColor,
                            onPressed: (_) => bloc
                                .add(PersonEvent.magnifyOrder(productOrder)),
                          ),
                        SlidableAction(
                            icon: Icons.edit,
                            backgroundColor: Theme.of(context).highlightColor,
                            onPressed: (_) async => bloc.add(
                                PersonEvent.editedPerson(
                                    await EditOrderDialog.open(
                                        context, productOrder)))),
                      ]),
                  child: InkWell(
                    onTap: () async {
                      bloc.add(PersonEvent.orderClicked(
                          productOrder,
                          isBlockedProduct(productOrder)
                              ? (await BinaryChoiceDialog.open(
                                  context,
                                  'Produkt gesperrt',
                                  'Das Produkt ist für den Gast aufgrund einer kürzlichen Bestellung noch gesperrt. Soll es dennoch bestellt werden?'))!
                              : true));
                    },
                    child: Center(
                      child: ListTile(
                          leading: SizedBox(
                            height: 100,
                            child: productOrder.symbol != null
                                ? FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(productOrder.symbol!),
                                  )
                                : Image.memory(
                                    productOrder.image!,
                                    gaplessPlayback: true,
                                  ),
                          ),
                          title: Text(productOrder.name),
                          subtitle: Text((() {
                            switch (productOrder.status) {
                              case OrderStatus.notOrdered:
                                return 'Nicht bestellt';
                              case OrderStatus.ordered:
                                return 'Bestellt am ${productOrder.lastIssueDate?.toCalendarDate()}';
                              case OrderStatus.received:
                                return 'Erhalten am ${productOrder.lastReceivedDate?.toCalendarDate()}';
                            }
                          })())),
                    ),
                  ),
                ))),
            // comment list
          ])),
      const SliverPadding(
          padding: EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(child: Divider(height: 10))),
      SliverList.list(
          children: state.comments
              .map(
                (comment) => CheckboxListTile(
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => BinaryChoiceDialog.open(
                                      context,
                                      'Kommentar löschen?',
                                      'Soll der ausgewählte Kommentar wirklich gelöscht werden?')
                                  .then((value) {
                                if (value == true)
                                  bloc.add(
                                      PersonEvent.commentDelete(comment.id));
                              })),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async => bloc.add(
                            PersonEvent.commentEdited(
                                await EditTextDialog.open(
                                    context, comment.content),
                                comment.id)),
                      ),
                    ],
                  ),
                  title: Text(
                    comment.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: comment.commentDone ? Colors.grey : Colors.black,
                    ),
                  ),
                  value: comment.commentDone,
                  onChanged: (bool? value) {
                    if (value != null) {
                      bloc.add(
                          PersonEvent.commentStatusChanged(comment, value));
                    }
                  },
                ),
              )
              .toList())
    ]);
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
