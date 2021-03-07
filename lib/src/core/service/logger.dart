import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

import '../index.dart';

class CustomLogger extends Logger {
  FirebaseCrashlytics _crashlytics;
  CustomLogger() : super() {
    Logger.level = Level.verbose;
    _crashlytics = sl();
  }

  @override
  void log(Level level, message, [error, StackTrace stackTrace]) {
    super.log(level, message, error, stackTrace);
    _crashlytics.log('[$level] - $message');
    // Whe might want to auto record crashlytics on errors???
    // if (error != null) {
    //   _crashlytics.recordError(
    //     error,
    //     stackTrace != null
    //         ? stackTrace
    //         : StackTrace.fromString('No Stack available'),
    //     context: 'CustomLogger error print',
    //   );
    // }
  }
}

Logger getLogger() {
  return CustomLogger();
}
