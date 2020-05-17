import 'package:flutter/material.dart';
import 'package:taskreminderapp/notifiers/app_state_notifier.dart';
import 'package:taskreminderapp/pages/main_page.dart';
import 'package:taskreminderapp/pages/reminder_page.dart';
import 'package:taskreminderapp/pages/weather_page.dart';
import 'package:taskreminderapp/utils/navigation_observer.dart';
import 'package:taskreminderapp/widgets/custom_app_bar.dart';

class AppScaffold extends StatefulWidget {
  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  NavigationObserver _navigationObserver;
  ValueNotifier<String> _currentRouteNotifier =
      ValueNotifier(AppRoutes.getInitialRoute());

  Widget _getPageByRouteName(
      String routeName, EdgeInsets padding, dynamic args) {
    switch (routeName) {
      case AppRoutes.MAIN:
        return MainPage();
      case AppRoutes.REMINDER:
        return ReminderPage();
      case AppRoutes.WEATHER:
        return WeatherPage();
    }
    return const SafeArea(child: Text('Undefined route'));
  }

  @override
  initState() {
    super.initState();
    _currentRouteNotifier.value = AppRoutes.getInitialRoute();
    _navigationObserver = NavigationObserver((String route) {
      if (route != null) {
        _currentRouteNotifier.value = route;
        AppStateNotifier.of(context, listen: false).setCurrentScreenText(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    return Scaffold(
      appBar: CustomAppBar(
        currentRouteNotifier: _currentRouteNotifier,
      ),
      body: Stack(
        children: <Widget>[
          Navigator(
            observers: [_navigationObserver],
            key: _navigationKey,
            initialRoute: AppRoutes.getInitialRoute(),
            onGenerateRoute: (RouteSettings settings) {
              return SlideBottomRoute(
                  settings: settings,
                  widget: _getPageByRouteName(
                    settings.name,
                    safePadding,
                    settings.arguments,
                  ));
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _currentRouteNotifier.dispose();
    super.dispose();
  }
}

class SlideBottomRoute extends PageRouteBuilder {
  final Widget widget;
  final settings;

  SlideBottomRoute({this.widget, this.settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
          settings: settings,
          transitionDuration: const Duration(milliseconds: 0),
        );
}

abstract class AppRoutes {
  static const String MAIN = '/';
  static const String REMINDER = '/reminder';
  static const String WEATHER = '/weather';

  static String getInitialRoute() {
    return MAIN;
  }
}
