import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product_type.dart';
import '../../until/utility.dart';
import 'bloc/edit_product_type_dialog_bloc.dart';

class EditProductTypeDialog extends StatefulWidget {
  final ProductType? productType;

  const EditProductTypeDialog({super.key, this.productType});

  @override
  State<EditProductTypeDialog> createState() => _EditProductTypeDialogState();
}

class _EditProductTypeDialogState extends State<EditProductTypeDialog> {
  _EditProductTypeDialogState();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProductTypeDialogBloc()
        ..add(EditProductTypeDialogEvent.setProductType(widget.productType)),
      child: Builder(
          builder: (context) => BlocConsumer<EditProductTypeDialogBloc,
                  EditProductTypeDialogState>(
              listener: (context, state) {
                switch (state.status) {
                  case EditProductTypeDialogStatus.cancel:
                    Navigator.pop(context, false);
                  case EditProductTypeDialogStatus.save:
                    Navigator.pop(context, true);
                  default:
                  // nothing to do
                }
              },
              bloc: context.read<EditProductTypeDialogBloc>(),
              builder: (context, state) {
                switch (state.status) {
                  case EditProductTypeDialogStatus.edit:
                    return buildEdit(
                        context.read<EditProductTypeDialogBloc>(), state);
                  default:
                    return const CircularProgressIndicator();
                }
              })),
    );
  }

  Widget buildEdit(
      EditProductTypeDialogBloc bloc, EditProductTypeDialogState state) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      titlePadding: const EdgeInsets.all(10),
      actionsPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.all(10),
      title: Text(
          'Produkttyp ${state.productType == null ? 'hinzufügen' : 'bearbeiten'}'),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: state.name,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      onChanged: (name) =>
                          bloc.add(EditProductTypeDialogEvent.updateName(name)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Feld ausfüllen.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue: state.daysBlocked,
                      maxLength: 3,
                      onChanged: (daysBlocked) => bloc.add(
                          EditProductTypeDialogEvent.updateDaysBlocked(
                              daysBlocked)),
                      decoration: const InputDecoration(
                        labelText: 'Geblockte Tage',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte Feld ausfüllen.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Bitte Zahl eingeben.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: state.symbol,
                      maxLength: 1,
                      onChanged: (symbol) => bloc
                          .add(EditProductTypeDialogEvent.updateSymbol(symbol)),
                      decoration: const InputDecoration(
                        labelText: 'Icon',
                      ),
                    ),
                    Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          state.imageAsBytes?.let((it) => Row(
                                    children: [
                                      SizedBox(
                                        height: 60,
                                        child: state.imageAsBytes?.let(
                                                (it) => Image.memory(it)) ??
                                            Container(),
                                      ),
                                      TextButton(
                                          onPressed: () => bloc.add(
                                              const EditProductTypeDialogEvent
                                                  .clearImage()),
                                          child: const Icon(Icons.clear))
                                    ],
                                  )) ??
                              Container(),
                          ElevatedButton(
                              onPressed: () => bloc.add(
                                  const EditProductTypeDialogEvent
                                      .selectImage()),
                              child: const Text('Bild auswählen')),
                        ])
                  ],
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () =>
                bloc.add(const EditProductTypeDialogEvent.cancel()),
            child: const Text('Abbrechen')),
        ElevatedButton(
            onPressed: formKey.currentState?.validate() == true &&
                    (state.symbol.isNotEmpty || state.imageAsBytes != null)
                ? () => bloc.add(const EditProductTypeDialogEvent.save())
                : null,
            child: const Text('Speichern'))
      ],
    );
  }
}
