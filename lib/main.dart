import 'package:boh_tourbuch/screens/comments/comments_screen.dart';
import 'package:boh_tourbuch/screens/faq/faq_screen.dart';
import 'package:boh_tourbuch/screens/orders/orders_screen.dart';
import 'package:boh_tourbuch/screens/person_list/person_list_screen.dart';
import 'package:boh_tourbuch/widgets/main_menu_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Tourbuch'),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
              ],
              bottom: const TabBar(
                tabs: [
                  MainMenuTab(title: 'Personen', iconData: Icons.person_search),
                  MainMenuTab(title: 'Kommentare', iconData: Icons.list_alt_sharp),
                  MainMenuTab(title: 'FAQ', iconData: Icons.question_answer)
                ],
              ),
            ),
            body: const TabBarView(
                children: [PersonListScreen(), CommentsScreen(), FaqScreen()])),
      ),
      routes: {
        '/order': (context) => const OrdersScreen()
      },
    );
  }
}
