import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/home/ui/sample_tab_navigation_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_classes.dart';
import '../../mock_service_locator.dart';
import '../../test_utils.dart';

void main() {
  group('sample tab navication tests:', () {
    FirebaseAnalyticsObserver analyticsObserver;
    setUp(() {
      analyticsObserver = FirebaseAnalyticsObserverMock();
      setupServiceLocatorMocks();
    });

    testWidgets('confirm tab interaction', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          BlocProvider<AnalyticsBloc>(
            create: (BuildContext context) => AnalyticsBlocMock(),
            child: SampleTabNavigationScreen(analyticsObserver),
          ),
        ),
      );

      // all tabs are visible
      expect(find.byIcon(Icons.ac_unit), findsOneWidget);
      expect(find.byIcon(Icons.alarm), findsOneWidget);

      // first tab is selected
      expect(find.text('AC Page'), findsOneWidget);
      expect(find.text('Alarm Page'), findsNothing);

      // tap the second tab
      await tester.tap(find.byIcon(Icons.alarm));
      await tester.pumpAndSettle();

      //second tab is selected
      expect(find.text('Alarm Page'), findsOneWidget);
      expect(find.text('AC Page'), findsNothing);
    });
  });
}
