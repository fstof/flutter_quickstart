import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

import '../application/service/service_locator.dart';

class CustomLogger extends Logger {
  Crashlytics _crashlytics;
  CustomLogger() : super() {
    Logger.level = Level.verbose;
    _crashlytics = sl();
  }

  @override
  void log(Level level, message, [error, StackTrace stackTrace]) {
    super.log(level, message, error, stackTrace);
    _crashlytics.log('[$level] - $message');
  }
}

Logger getLogger() {
  return CustomLogger();
}
