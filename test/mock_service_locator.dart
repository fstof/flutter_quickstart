import 'package:firebase_analytics/observer.dart';
import 'package:flutter_quick_start/src/core/index.dart';
import 'package:get_it/get_it.dart';

import 'mock_classes.dart';

GetIt sl = GetIt.instance;

void setupServiceLocatorMocks() {
  sl.registerLazySingleton<NavigationService>(() => NavigationServiceMock());
  sl.registerLazySingleton<FirebaseAnalyticsObserver>(
      () => FirebaseAnalyticsObserverMock());
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsServiceMock());
}
