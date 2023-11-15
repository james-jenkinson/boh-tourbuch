import 'package:boh_tourbuch/models/product_type.dart';
import 'package:boh_tourbuch/screens/settings/bloc/settings_bloc.dart';
import 'package:boh_tourbuch/widgets/edit_product_type_dialog/edit_product_type_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    _settingsBloc = SettingsBloc()..add(LoadOrdersEvent());
    super.initState();
  }

  @override
  void dispose() {
    _settingsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: _settingsBloc,
        listener: (context, state) async {
          if (state is OpenDialog) {
            openDialog(state.productType);
          }
        },
        builder: (context, state) {
          if (state is SettingsInitial) {
            return getScaffold(const CircularProgressIndicator());
          } else if (state is ProductTypesLoaded) {
            return getScaffold(ListView.builder(
              itemCount: state.productTypes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    state.productTypes[index].symbol,
                    style: const TextStyle(fontSize: 26),
                  ),
                  title: Text(state.productTypes[index].name),
                  subtitle: Text(
                      'Sperrung von ${state.productTypes[index].daysBlocked} Tagen'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.productTypes[index].deletable)
                        IconButton(
                            onPressed: () => _settingsBloc.add(
                                DeleteProductTypeEvent(
                                    state.productTypes[index].id)),
                            icon: const Icon(Icons.delete)),
                      IconButton(
                          onPressed: () => _settingsBloc.add(
                              OpenProductTypeDialogEvent(
                                  state.productTypes[index])),
                          icon: const Icon(Icons.edit))
                    ],
                  ),
                );
              },
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            ));
          }
          return getScaffold(Container());
        });
  }

  Scaffold getScaffold(Widget body) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _settingsBloc.add(OpenProductTypeDialogEvent(null)),
      ),
    );
  }

  void openDialog(ProductType? productType) async {
    _settingsBloc.add(
      DialogClosedEvent(
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return EditProductTypeDialog(productType: productType);
          },
        ),
      ),
    );
  }
}
