import 'package:boh_tourbuch/screens/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/main_menu_tab.dart';
import '../comments/comments_screen.dart';
import '../faq/faq_screen.dart';
import '../person_list/person_list_screen.dart';

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
            Navigator.pushNamed(context, '/settings')
                .then((value) => _homeBloc.add(CloseDialogEvent()));
          }
        },
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Tourbuch'),
                actions: [
                  IconButton(
                      onPressed: () => _homeBloc.add(OpenSettingsDialogEvent()),
                      icon: const Icon(Icons.settings))
                ],
                bottom: const TabBar(
                  tabs: [
                    MainMenuTab(
                        title: 'Personen', iconData: Icons.person_search),
                    MainMenuTab(
                        title: 'Kommentare', iconData: Icons.list_alt_sharp),
                    MainMenuTab(title: 'FAQ', iconData: Icons.question_answer)
                  ],
                ),
              ),
              body: const TabBarView(children: [
                PersonListScreen(),
                CommentsScreen(),
                FaqScreen()
              ])),
        ));
  }

  Future<dynamic> buildShowDialog(BuildContext context, bool wrongPassword) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
  }
}
