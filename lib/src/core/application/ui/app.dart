import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';

import '../../core.dart';
import '../../navigation/routing/router.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  NavigationService _navigationService;
  ApplicationBloc _applicationBloc;
  AnalyticsBloc _analyticsBloc;

  @override
  void initState() {
    super.initState();
    _navigationService = sl();
    _applicationBloc = ApplicationBloc(applicationDao: sl());
    _analyticsBloc = sl();

    _applicationBloc.dispatch(ApplicationEventAppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ApplicationBloc>(builder: (_) => _applicationBloc),
        BlocProvider<AnalyticsBloc>(builder: (_) => _analyticsBloc),
      ],
      child: BlocListener(
        bloc: _applicationBloc,
        listener: (_, state) {
          if (state is ApplicationStateLoggedIn) {
            _navigationService.navigateReplacement(ROUTE_HOME);
          } else if (state is ApplicationStateLoggedOut) {
            _navigationService.navigateReplacement(ROUTE_LOGIN);
          }
        },
        child: MaterialApp(
          title: 'Flutter Quick Start',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          navigatorObservers: [sl<FirebaseAnalyticsObserver>()],
          initialRoute: ROUTE_SPLASH,
          navigatorKey: _navigationService.navigatorKey,
          onGenerateRoute: generateRoute,
        ),
      ),
    );
  }
}
