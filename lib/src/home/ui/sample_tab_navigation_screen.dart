import 'dart:math';

import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/core/core.dart';

import '../bloc/sample_tab_navigation_screen_bloc.dart';

class SampleTabNavigationScreen extends StatefulWidget {
  final FirebaseAnalyticsObserver observer;
  SampleTabNavigationScreen(this.observer);

  @override
  _SampleTabNavigationScreenState createState() =>
      _SampleTabNavigationScreenState();
}

class _SampleTabNavigationScreenState extends State<SampleTabNavigationScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  SampleTabNavigationScreenBloc _tabNavigationScreenBloc;
  NavigationService _navigationService;
  AnalyticsBloc _analyticsBloc;

  TabController _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _analyticsBloc = BlocProvider.of(context);
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
          bloc: _tabNavigationScreenBloc,
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
    widget.observer.subscribe(this, ModalRoute.of(context));
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
    _analyticsBloc.add(
      AnalyticsEventScreenView('TabNumber_$selectedIndex'),
    );
  }
}
