import 'package:flutter/material.dart';
import 'package:flutter_quick_start/src/auth/auth.dart';
import 'package:flutter_quick_start/src/core/application/ui/splash_screen.dart';
import 'package:flutter_quick_start/src/home/home.dart';
import 'package:flutter_quick_start/src/home/ui/sample_navigation_screen.dart';
import 'package:flutter_quick_start/src/home/ui/sample_tab_navigation_screen.dart';

import '../../core.dart';
import '../ui/unknown_route.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  final logger = getLogger();

  logger.d('navigating to ${routeSettings.name}');
  switch (routeSettings.name) {
    case ROUTE_SPLASH:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'SplashScreen'),
          builder: (context) => SplashScreen());
    case ROUTE_HOME:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'HomeScreen'),
          builder: (context) => HomeScreen());
    case ROUTE_NAVS:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'SampleNavigationScreen'),
          builder: (context) =>
              SampleNavigationScreen(routeSettings.arguments as int));
    case ROUTE_TABS:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'SampleTabNavigationScreen'),
          builder: (context) => SampleTabNavigationScreen(sl(), sl()));
    case ROUTE_LOGIN:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'LoginScreen'),
          builder: (context) => LoginScreen());
    default:
      return MaterialPageRoute(
          settings: RouteSettings(name: 'UnknownRoute'),
          builder: (context) => UnknownRoute());
  }
}
