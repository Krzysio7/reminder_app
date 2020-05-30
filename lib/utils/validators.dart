import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:taskreminderapp/config/strings.dart';

abstract class Validators {
  static final emailRegexp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final plZipCodeRegexp = RegExp(r"\d{2}-\d{3}");

  static final minPasswordLength = 6;

  static String titleValid(BuildContext context, String title) {
    if (title.trim().isEmpty) {
      return FlutterI18n.translate(context, Strings.titleRequired);
    }
    return null;
  }
  static String descriptionValid(BuildContext context, String description) {
    if (description.trim().isEmpty) {
      return FlutterI18n.translate(context, Strings.descriptionRequired);
    }
    return null;
  }
}
