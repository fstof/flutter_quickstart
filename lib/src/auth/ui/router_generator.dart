import 'package:flutter/material.dart';
import 'package:flutter_quick_start/src/core/index.dart';

import '../index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case ROUTE_LOGIN:
        return Router.buildRoute(
          LoginScreen(),
          'LoginScreen',
        );
      default:
        return null;
    }
  }
}
