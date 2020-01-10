import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  group('Application Integration Tests Ready', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect(
        dartVmServiceUrl: args[0],
        printCommunication: false,
      );
    });

    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    // test('up and running', () async {});
  });
}
