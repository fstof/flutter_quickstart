import 'package:firebase_analytics/observer.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/home/bloc/sample_tab_navigation_screen_bloc.dart';
import 'package:mockito/mockito.dart';

class FirebaseAnalyticsObserverMock extends Mock
    implements FirebaseAnalyticsObserver {}

class SampleTabNavigationScreenBlocMock extends Mock
    implements SampleTabNavigationScreenBloc {}

class AnalyticsServiceMock extends Mock implements AnalyticsService {}

class NavigationServiceMock extends Mock implements NavigationService {}
