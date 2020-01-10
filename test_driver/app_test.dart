import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  group('Application Integration Tests', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect(dartVmServiceUrl: args[0]);
    });

    tearDownAll(() {
      if (driver != null) {
        driver.close();
      }
    });

    test('Test login', () async {
      await Future.delayed(Duration(seconds: 5));
      final username = 'eve.holt@reqres.in';
      await driver.tap(find.byValueKey('__username_text_field__'));
      await driver.enterText(username);
      await driver.waitFor(find.text(username));

      final password = 'password';
      await driver.tap(find.byValueKey('__password_text_field__'));
      await driver.enterText(password);
      await driver.waitFor(find.text(password));

      await driver.tap(find.text('Click to login'));
      await driver.waitFor(find.text('Home'));

      await driver.tap(find.text('Logout'));
      await driver.waitFor(find.text('Login'));
    });
  });
}
