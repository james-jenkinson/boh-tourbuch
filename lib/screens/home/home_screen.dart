import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../theme_provider.dart';
import '../../until/licence.dart';
import '../../widgets/main_menu_tab.dart';
import '../comment/comment_screen.dart';
import '../orders/orders_screen.dart';
import '../person_list/person_list_screen.dart';
import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = HomeBloc();
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return BlocListener(
        bloc: _homeBloc,
        listener: (context, state) async {
          if (state is OpenSettingsDialog) {
            _homeBloc.add(
                DialogCompletedEvent(await buildShowDialog(context, false)));
          } else if (state is WrongPassword) {
            _homeBloc.add(
                DialogCompletedEvent(await buildShowDialog(context, true)));
          } else if (state is NavigateToSettings) {
            await Navigator.pushNamed(context, '/settings')
                .then((value) => _homeBloc.add(CloseDialogEvent()));
          } else if (state is NavigateToFAQ) {
            await Navigator.pushNamed(context, '/faq');
          }
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: Row(children: [
                  Image.asset(
                    'assets/app_icon.png',
                    color: Theme.of(context).primaryColor,
                    height: themeProvider.scale * 30,
                  ),
                  const Text('Tourbuch')
                ]),
                actions: [
                  IconButton(
                      onPressed: () => themeProvider.zoomOut(),
                      icon: const Icon(Icons.zoom_out)),
                  IconButton(
                      onPressed: () => themeProvider.zoomIn(),
                      icon: const Icon(Icons.zoom_in)),
                  PopupMenuButton<String>(
                    onSelected: (value) => handleClick(value, _homeBloc.add),
                    itemBuilder: (BuildContext context) {
                      return {'FAQ', 'Einstellungen', 'Lizenzen'}
                          .map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    MainMenuTab(
                        title: 'Personen', iconData: Icons.person_search),
                    MainMenuTab(
                        title: 'Bestellungen', iconData: Icons.list_alt_sharp),
                    MainMenuTab(title: 'Kommentare', iconData: Icons.comment),
                  ],
                ),
              ),
              body: const TabBarView(children: [
                PersonListScreen(),
                OrdersScreen(),
                CommentScreen(),
              ])),
        ));
  }

  Future<bool> buildShowDialog(BuildContext context, bool wrongPassword) async {
    final state = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,
            title: const Text('Adminpasswort eingeben'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Die Einstellungsseite ist nur nach Eingabe das '
                    'Adminpassworts erreichbar.'),
                TextField(
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _homeBloc.password,
                  decoration: InputDecoration(
                      labelText: 'Adminpasswort eingeben',
                      errorText: wrongPassword
                          ? 'Das eingegebene Passwort ist falsch.'
                          : null),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Abbrechen')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Login'))
            ],
          );
        });

    return state == true;
  }

  void handleClick(String value, void Function(HomeEvent) addEvent) {
    switch (value) {
      case 'FAQ':
        addEvent(OpenFAQEvent());
      case 'Einstellungen':
        addEvent(OpenSettingsDialogEvent());
      case 'Lizenzen':
        PackageInfo.fromPlatform().then((packageInfo) => showAboutDialog(
            context: context,
            applicationName: 'Tourbuch',
            applicationVersion:
                'Version: ${packageInfo.version} - ${packageInfo.buildNumber}',
            children: [const Text(appLicence)]));
      default:
    }
  }
}
