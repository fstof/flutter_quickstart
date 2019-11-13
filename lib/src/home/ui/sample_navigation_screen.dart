import 'package:flutter/material.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/core/navigation/service/navigation_service.dart';

class SampleNavigationScreen extends StatelessWidget {
  final _log = getLogger();
  final NavigationService nav = sl();
  final int someNumber;

  SampleNavigationScreen(this.someNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Another Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your number is $someNumber',
              style: Theme.of(context).textTheme.title,
            ),
            RaisedButton(
              child: Text('Go forward'),
              onPressed: () => nav.navigateForward(
                ROUTE_NAVS,
                arguments: someNumber + 1,
              ),
            ),
            RaisedButton(
              child: Text('Go forward and wait for a result'),
              onPressed: () async {
                var ans = await nav.navigateForward(
                  ROUTE_NAVS,
                  arguments: someNumber + 1,
                );
                _log.i('nav came back with answer $ans');
              },
            ),
            RaisedButton(
              child: Text('Go backward'),
              onPressed: () => nav.goBack(someNumber),
            ),
            RaisedButton(
              child: Text('Replace this'),
              onPressed: () => nav.navigateReplacement(
                ROUTE_NAVS,
                arguments: someNumber + 1,
              ),
            ),
            RaisedButton(
              child: Text('Replace root'),
              onPressed: () => nav.navigateRootReplacement(
                ROUTE_NAVS,
                arguments: someNumber + 1,
              ),
            ),
            RaisedButton(
              child: Text('Home'),
              onPressed: () => nav.navigateRootReplacement(ROUTE_HOME),
            ),
            RaisedButton(
              child: Text('Invalid route'),
              onPressed: () {
                nav.navigateForward('boo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
