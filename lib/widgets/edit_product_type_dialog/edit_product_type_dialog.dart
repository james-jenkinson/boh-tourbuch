import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/product_type.dart';
import 'bloc/edit_product_type_dialog_bloc.dart';

class EditProductTypeDialog extends StatefulWidget {
  final ProductType? productType;

  const EditProductTypeDialog({super.key, this.productType});

  @override
  State<EditProductTypeDialog> createState() => _EditProductTypeDialogState();
}

class _EditProductTypeDialogState extends State<EditProductTypeDialog> {
  late EditProductTypeDialogBloc _editProductTypeDialogBloc;

  _EditProductTypeDialogState();

  @override
  void initState() {
    _editProductTypeDialogBloc = EditProductTypeDialogBloc(widget.productType);
    super.initState();
  }

  @override
  void dispose() {
    _editProductTypeDialogBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return BlocConsumer(
        listener: (context, state) {
          if (state is ClosedDialog) {
            Navigator.pop(context, state.saveClicked);
          }
        },
        bloc: _editProductTypeDialogBloc,
        builder: (context, state) {
          if (state is EditProductTypeDialogInitial) {
            return AlertDialog(
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
                            controller: _editProductTypeDialogBloc.name,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                            ),
                            autovalidateMode: AutovalidateMode.disabled,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte Feld ausfüllen.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _editProductTypeDialogBloc.daysBlocked,
                            maxLength: 3,
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: const InputDecoration(
                              labelText: 'Geblockte Tage',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte Feld ausfüllen.';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _editProductTypeDialogBloc.symbol,
                            maxLength: 1,
                            autovalidateMode: AutovalidateMode.disabled,
                            decoration: const InputDecoration(
                              labelText: 'Icon',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte Feld ausfüllen.';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      onChanged: () => _editProductTypeDialogBloc
                          .add(FormChangedEvent(formKey.currentState?.validate())),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () =>
                        _editProductTypeDialogBloc.add(CancelClickedEvent()),
                    child: const Text('Abbrechen')),
                ElevatedButton(
                    onPressed: state.validate
                        ? () =>
                            _editProductTypeDialogBloc.add(SaveClickedEvent())
                        : null,
                    child: const Text('Speichern'))
              ],
            );
          }
          return Container();
        });
  }
}
