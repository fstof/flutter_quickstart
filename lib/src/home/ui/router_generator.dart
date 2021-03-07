import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case ROUTE_SPLASH:
        return MyRouter.buildRoute(
          SplashScreen(),
          'SplashScreen',
        );
      case ROUTE_HOME:
        return MyRouter.buildRoute(
          HomeScreen(),
          'HomeScreen',
        );
      case ROUTE_NAVS:
        return MyRouter.buildRoute(
          SampleNavigationScreen(routeSettings.arguments as int),
          'SampleNavigationScreen',
        );
      case ROUTE_TABS:
        return MyRouter.buildRoute(
          SampleTabNavigationScreen(),
          'SampleTabNavigationScreen',
        );
      default:
        return null;
    }
  }
}
