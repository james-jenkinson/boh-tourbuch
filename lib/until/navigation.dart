import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

NavigatorState navigator() {
  return Navigator.of(navigatorKey.currentContext!);
}
