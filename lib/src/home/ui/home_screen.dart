import 'dart:math';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/core/core.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NavigationService _navigationService;
  ApplicationBloc _applicationBloc;

  @override
  void initState() {
    super.initState();
    _navigationService = sl();
    _applicationBloc = BlocProvider.of(context);
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
