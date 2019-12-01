import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      return _buildRoute(
        SplashScreen(),
        'SplashScreen',
      );
    case ROUTE_HOME:
      return _buildRoute(
        HomeScreen(),
        'HomeScreen',
      );
    case ROUTE_NAVS:
      return _buildRoute(
        SampleNavigationScreen(routeSettings.arguments as int),
        'SampleNavigationScreen',
      );
    case ROUTE_TABS:
      return _buildRoute(
        SampleTabNavigationScreen(sl()),
        'SampleTabNavigationScreen',
      );
    case ROUTE_LOGIN:
      return _buildRoute(
        LoginScreen(),
        'LoginScreen',
      );
    default:
      return _buildRoute(
        UnknownRoute(),
        'UnknownRoute',
      );
  }
}

Route _buildRoute(Widget child, String name) {
  final logger = getLogger();
  return MaterialPageRoute(
    settings: RouteSettings(name: name),
    builder: (context) => BlocListener<NotificationBloc, NotificationState>(
      bloc: sl<NotificationBloc>(),
      listener: (context, state) async {
        try {
          var flush = Flushbar(
            title: state.title,
            message: state.message,
            duration: state.duration,
          );
          await flush.show(context);
        } catch (error) {
          logger.e(error);
        }
      },
      child: child,
    ),
  );
}
