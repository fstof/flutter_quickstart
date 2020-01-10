import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/app/index.dart';
import 'package:flutter_quick_start/src/core/index.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NavigationService _navigationService;
  PushHandler _pushHandler;
  ApplicationBloc _applicationBloc;
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _navigationService = sl();
    _applicationBloc = ApplicationBloc(
      userRepo: sl(),
      appConfig: sl(),
      remoteConfig: sl(),
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
    _notificationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ApplicationBloc>(create: (_) => _applicationBloc),
          BlocProvider<NotificationBloc>(create: (_) => _notificationBloc),
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
