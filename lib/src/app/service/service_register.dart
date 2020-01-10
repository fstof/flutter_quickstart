import 'package:get_it/get_it.dart';

import '../index.dart';

void registerServices(GetIt sl) {
  sl.registerLazySingleton(() => ApplicationDao(storage: sl()));
}
