import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_quick_start/src/auth/auth.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/core/api/core_http_client.dart';
import 'package:flutter_quick_start/src/core/storage/token_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:json_store/json_store.dart';

import '../../navigation/service/navigation_service.dart';
import '../dao/application_dao.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Navigation
  sl.registerLazySingleton(() => NavigationService());

  // Storage / Dao's / Api's
  sl.registerLazySingleton(() => JsonStore());
  sl.registerLazySingleton(() => TokenStorage(localStorage: sl()));
  sl.registerLazySingleton(() => ApplicationDao(storage: sl()));
  sl.registerLazySingleton<BaseClient>(() => CoreHttpClient(Client()));

  // Login
  sl.registerLazySingleton(
      () => LoginApi(baseClient: sl(), tokenStorage: sl()));
  sl.registerLazySingleton(() => LoginRepo(loginApi: sl()));

  // Firebase
  sl.registerLazySingleton(() => Crashlytics.instance);
  sl.registerLazySingleton(() => FirebaseAnalytics());
  sl.registerLazySingleton(() => FirebaseAnalyticsObserver(analytics: sl()));
  sl.registerLazySingleton(() => FirebasePerformance.instance);
  sl.registerLazySingleton(() => AnalyticsBloc(
      analytics: sl(), analyticsObserver: sl(), crashlytics: sl()));
}
