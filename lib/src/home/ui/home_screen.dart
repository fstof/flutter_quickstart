import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/app/index.dart';
import 'package:flutter_quick_start/src/core/index.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationService _navigationService;
  ApplicationBloc _applicationBloc;
  NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _navigationService = sl();
    _applicationBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('HomeView'),
              RaisedButton(
                child: Text('Navigation Sample screen'),
                onPressed: () {
                  _navigationService.navigateForward(
                    ROUTE_NAVS,
                    arguments: Random().nextInt(999),
                  );
                },
              ),
              RaisedButton(
                child: Text('Tab Navigation'),
                onPressed: () {
                  _navigationService.navigateForward(ROUTE_TABS);
                },
              ),
              RaisedButton(
                child: Text('Crash!'),
                onPressed: () {
                  sl<Crashlytics>().crash();
                },
              ),
              RaisedButton(
                // this fails as it cannot find the Scaffold in the current BuildContext.
                // for this to word, extract this button into its own widges to get a new BuildContext
                child: Text('Stock Notification'),
                onPressed: () {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('hello message'),
                    ),
                  );
                },
              ),
              RaisedButton(
                child: Text('Notification'),
                onPressed: () {
                  _notificationBloc.add(NotificationEvent(
                    title: 'my title',
                    message: 'hello message',
                  ));
                },
              ),
              RaisedButton(
                child: Text('Logout'),
                onPressed: () {
                  _applicationBloc.add(ApplicationEventUserLogOut());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
