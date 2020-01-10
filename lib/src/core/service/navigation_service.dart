import 'package:flutter/widgets.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<T> navigateForward<T>(String routeName, {arguments}) {
    return navigatorKey.currentState
        .pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T> navigateReplacement<T, TO>(String routeName,
      {TO result, arguments}) {
    return navigatorKey.currentState.pushReplacementNamed<T, TO>(routeName,
        result: result, arguments: arguments);
  }

  Future<T> navigateRootReplacement<T>(String routeName, {arguments}) {
    goBackToRoot();
    return navigatorKey.currentState.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  bool goBack<T>(T result) {
    return navigatorKey.currentState.pop(result);
  }

  void goBackToRoot() {
    return navigatorKey.currentState
        .popUntil((Route<dynamic> route) => route.isFirst);
  }
}
