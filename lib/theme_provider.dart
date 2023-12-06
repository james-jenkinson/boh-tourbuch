import 'dart:math';

import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  double scale = 1;

  ThemeData get theme => ThemeData.light()
    ..textTheme.apply(fontSizeFactor: scale)
    ..primaryTextTheme.apply(fontSizeFactor: scale);

  void zoomIn() {
    scale = min(1.8, scale + 0.2);
    notifyListeners();
  }

  void zoomOut() {
    scale = max(0.8, scale - 0.2);
    notifyListeners();
  }
}
