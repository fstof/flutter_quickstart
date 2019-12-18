import 'package:flutter_quick_start/src/core/core.dart';
import 'package:get_it/get_it.dart';

import 'mock_classes.dart';

GetIt sl = GetIt.instance;

void setupServiceLocatorMocks() {
  sl.registerLazySingleton<NavigationService>(() => NavigationServiceMock());
}
