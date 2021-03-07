import 'package:flutter/material.dart';

import '../../core/index.dart';
import '../index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case ROUTE_LOGIN:
        return MyRouter.buildRoute(
          LoginScreen(),
          'LoginScreen',
        );
      default:
        return null;
    }
  }
}
