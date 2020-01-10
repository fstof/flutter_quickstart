import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'src/app/index.dart';
import 'src/core/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  FlavorConfig(
    flavor: Flavor.NONPROD,
    values: FlavorValues(
      someFlavorConfig: true,
    ),
  );

  setupServiceLocator();
  runZoned<Future<void>>(() async {
    runApp(App());
  }, onError: (dynamic exception, StackTrace stack, {dynamic context}) {
    getLogger().wtf(exception);
    Crashlytics.instance.recordError(exception, stack, context: context);
  });
}
