import 'dart:math';

import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/index.dart';
import '../bloc/sample_tab_navigation_screen_bloc.dart';

class SampleTabNavigationScreen extends StatefulWidget {
  @override
  _SampleTabNavigationScreenState createState() =>
      _SampleTabNavigationScreenState();
}

class _SampleTabNavigationScreenState extends State<SampleTabNavigationScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  SampleTabNavigationScreenBloc _tabNavigationScreenBloc;
  NavigationService _navigationService;
  AnalyticsService _analyticsService;
  final FirebaseAnalyticsObserver observer = sl();

  TabController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _analyticsService = sl();
    _tabNavigationScreenBloc = SampleTabNavigationScreenBloc();
    _navigationService = sl();
    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: selectedIndex,
    );
    _controller.addListener(() {
      setState(() {
        if (selectedIndex != _controller.index) {
          selectedIndex = _controller.index;
          _sendCurrentTabToAnalytics();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabNavigationScreenBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Another Page')),
      body: Center(
        child: BlocListener(
          cubit: _tabNavigationScreenBloc,
          listener: (_, TabState state) {
            _controller.animateTo(state.currentTab);
          },
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              Center(
                  child: Column(
                children: <Widget>[
                  Text('AC Page'),
                  RaisedButton(
                    child: Text('Navigation Sample screen'),
                    onPressed: () {
                      _navigationService.navigateForward(
                        ROUTE_NAVS,
                        arguments: Random().nextInt(999),
                      );
                    },
                  ),
                ],
              )),
              Center(
                  child: Column(
                children: <Widget>[
                  Text('Alarm Page'),
                  RaisedButton(
                    child: Text('Navigation Sample screen'),
                    onPressed: () {
                      _navigationService.navigateForward(
                        ROUTE_NAVS,
                        arguments: Random().nextInt(999),
                      );
                    },
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TabBar(
        controller: _controller,
        labelColor: Colors.green,
        tabs: <Widget>[
          Tab(child: Text('AC'), icon: Icon(Icons.ac_unit)),
          Tab(child: Text('Alarm'), icon: Icon(Icons.alarm)),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    _analyticsService.logScreenView(screenName: 'TabNumber_$selectedIndex');
    // .add(
    //   AnalyticsEventScreenView('TabNumber_$selectedIndex'),
    // );
  }
}
