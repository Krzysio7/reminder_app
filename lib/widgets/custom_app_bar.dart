import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:taskreminderapp/config/strings.dart';

import '../app_scaffold.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final ValueNotifier<String> currentRouteNotifier;

  CustomAppBar({
    this.currentRouteNotifier,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + 0.0,
      );
}

class _CustomAppBarState extends State<CustomAppBar> {
  String _getRouteName(String route) {
    switch (route) {
      case AppRoutes.MAIN:
        return FlutterI18n.translate(
          context,
          Strings.home,
        );
        case AppRoutes.WEATHER:
        return FlutterI18n.translate(
          context,
          Strings.weather,
        );
        case AppRoutes.REMINDER:
        return FlutterI18n.translate(
          context,
          Strings.reminder,
        );
      default:
        return FlutterI18n.translate(
          context,
          Strings.undefined_page,
        );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.currentRouteNotifier.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        _getRouteName(widget.currentRouteNotifier.value),
      ),
    );
  }
}
