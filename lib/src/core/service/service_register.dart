import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get_it/get_it.dart';
import 'package:json_store/json_store.dart';

import '../index.dart';

void registerServices(GetIt sl) {
  // App Config
  sl.registerLazySingleton(() => RemoteConfig());
  sl.registerLazySingleton(() => AppConfig(remoteConfig: sl()));

  // Navigation
  sl.registerLazySingleton(() => NavigationService());

  // Storage / Dao's / Api's
  sl.registerLazySingleton(() => JsonStore());
  sl.registerLazySingleton(() => TokenStorage(localStorage: sl()));
  sl.registerLazySingleton<Dio>(() => CoreDioClient(tokenStorage: sl()));

  sl.registerLazySingleton(() => FlutterAppAuth());

  // Firebase
  sl.registerLazySingleton(() => Crashlytics.instance);
  sl.registerLazySingleton(() => FirebaseAnalytics());
  sl.registerLazySingleton(() => FirebaseAnalyticsObserver(
        analytics: sl(),
      ));
  sl.registerLazySingleton(() => FirebasePerformance.instance);
  sl.registerLazySingleton(() => FirebaseMessaging());

  sl.registerLazySingleton(() =>
      NotificationBloc()); // not exactly happy about this one here as it is a bloc and should be provided
  sl.registerLazySingleton(() => AnalyticsService(
        analytics: sl(),
        analyticsObserver: sl(),
        crashlytics: sl(),
      ));
}
