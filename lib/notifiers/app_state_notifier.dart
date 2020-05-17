import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppStateNotifier with ChangeNotifier {
  String currentScreenText = '';

  void setCurrentScreenText(String text) {
    currentScreenText = text;
    notifyListeners();
  }

  static AppStateNotifier of(BuildContext context, {bool listen = true}) =>
      Provider.of<AppStateNotifier>(context, listen: listen);
}
