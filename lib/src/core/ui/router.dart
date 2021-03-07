import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/index.dart' as auth;
import '../../home/index.dart' as home;
import '../index.dart';

class MyRouter {
  static final _logger = getLogger();

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    _logger.d('navigating to ${routeSettings.name}');
    Route route = auth.RouteGenerator.generateRoute(routeSettings) ??
        home.RouteGenerator.generateRoute(routeSettings) ??
        MyRouter.buildRoute(
          UnknownRoute(),
          'unknown',
        );
    return route;
  }

  static Route buildRoute(Widget child, String name) {
    return MaterialPageRoute(
      settings: RouteSettings(name: name),
      builder: (context) => BlocListener<NotificationBloc, NotificationState>(
        cubit: sl<NotificationBloc>(),
        listener: (context, state) async {
          try {
            var flush = Flushbar(
              title: state.title,
              message: state.message,
              duration: state.duration,
              flushbarStyle: FlushbarStyle.GROUNDED,
            );
            await flush.show(context);
          } catch (error) {
            _logger.e(error);
          }
        },
        child: child,
      ),
    );
  }
}
