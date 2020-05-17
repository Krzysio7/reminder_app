import 'package:flutter/material.dart';

class NavigationObserver extends NavigatorObserver {
  final Function(String currentRouteName) onRouteChanged;

  NavigationObserver(this.onRouteChanged);

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    _onRouteChanged(newRoute.settings.name);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    _onRouteChanged(route.settings.name);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    _onRouteChanged(previousRoute.settings.name);
  }

  void _onRouteChanged(String currentRouteName) {
    Future.delayed(Duration.zero, () {
      onRouteChanged(currentRouteName);
    });
  }
}
