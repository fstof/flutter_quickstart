import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/core/notification/push_handler.dart';

import '../../core.dart';
import '../../navigation/routing/router.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NavigationService _navigationService;
  PushHandler _pushHandler;
  ApplicationBloc _applicationBloc;
  AnalyticsBloc _analyticsBloc;
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _navigationService = sl();
    _applicationBloc = ApplicationBloc(applicationDao: sl());
    _analyticsBloc = AnalyticsBloc(
      analytics: sl(),
      analyticsObserver: sl(),
      crashlytics: sl(),
    );
    _notificationBloc = sl();
    _pushHandler = PushHandler(_notificationBloc, sl());

    _pushHandler.setupPush();
    _applicationBloc.add(ApplicationEventAppStarted());
  }

  @override
  void dispose() {
    super.dispose();
    _applicationBloc.close();
    _analyticsBloc.close();
    _notificationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          // BlocProvider.value(value: _applicationBloc),
          // BlocProvider.value(value: _analyticsBloc),
          // BlocProvider.value(value: _notificationBloc),
          BlocProvider<ApplicationBloc>(builder: (_) => _applicationBloc),
          BlocProvider<AnalyticsBloc>(builder: (_) => _analyticsBloc),
          BlocProvider<NotificationBloc>(builder: (_) => _notificationBloc),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ApplicationBloc, ApplicationState>(
              bloc: _applicationBloc,
              listener: (_, state) {
                if (state is ApplicationStateLoggedIn) {
                  _navigationService.navigateReplacement(ROUTE_HOME);
                } else if (state is ApplicationStateLoggedOut) {
                  _navigationService.navigateReplacement(ROUTE_LOGIN);
                }
              },
            ),
          ],
          child: MaterialApp(
            title: 'Flutter Quick Start',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            navigatorObservers: [sl<FirebaseAnalyticsObserver>()],
            initialRoute: ROUTE_SPLASH,
            navigatorKey: _navigationService.navigatorKey,
            onGenerateRoute: Router.generateRoute,
          ),
        ));
  }
}
