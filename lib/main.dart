import 'package:boh_tourbuch/screens/comments/comments_screen.dart';
import 'package:boh_tourbuch/screens/faq/faq_screen.dart';
import 'package:boh_tourbuch/screens/home/home_screen.dart';
import 'package:boh_tourbuch/screens/orders/orders_screen.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/orders': (context) => const OrdersScreen(),
        '/faq': (context) => const FaqScreen(),
        '/comments': (context) => const CommentsScreen(),
      },
    );
  }
}
