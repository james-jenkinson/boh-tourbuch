import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/faq/faq_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/person/person_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'theme_provider.dart';
import 'until/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // enable fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          builder: (BuildContext context, Widget? child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                  textScaler: TextScaler.linear(Provider.of<ThemeProvider>(context).scale)),
              child: child ?? Container(),
            );
          },
          title: 'Tourbuch',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffeb5d40)),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
          routes: {
            '/person': (context) => const PersonScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/faq': (context) => const FaqScreen(),
          },
        ));
  }
}
