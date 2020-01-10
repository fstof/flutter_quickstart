import 'package:firebase_analytics/observer.dart';
import 'package:flutter_quick_start/src/core/index.dart';
import 'package:flutter_quick_start/src/home/index.dart';
import 'package:mockito/mockito.dart';

class FirebaseAnalyticsObserverMock extends Mock
    implements FirebaseAnalyticsObserver {}

class SampleTabNavigationScreenBlocMock extends Mock
    implements SampleTabNavigationScreenBloc {}

class AnalyticsServiceMock extends Mock implements AnalyticsService {}

class NavigationServiceMock extends Mock implements NavigationService {}
