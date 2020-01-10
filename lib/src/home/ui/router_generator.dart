import 'package:flutter/material.dart';
import 'package:flutter_quick_start/src/core/index.dart';

import '../index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case ROUTE_SPLASH:
        return Router.buildRoute(
          SplashScreen(),
          'SplashScreen',
        );
      case ROUTE_HOME:
        return Router.buildRoute(
          HomeScreen(),
          'HomeScreen',
        );
      case ROUTE_NAVS:
        return Router.buildRoute(
          SampleNavigationScreen(routeSettings.arguments as int),
          'SampleNavigationScreen',
        );
      case ROUTE_TABS:
        return Router.buildRoute(
          SampleTabNavigationScreen(),
          'SampleTabNavigationScreen',
        );
      default:
        return null;
    }
  }
}
