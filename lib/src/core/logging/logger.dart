import 'package:logger/logger.dart';

class CustomLogger extends Logger {
  CustomLogger() : super() {
    Logger.level = Level.verbose;
  }
}

Logger getLogger() {
  return CustomLogger();
}
